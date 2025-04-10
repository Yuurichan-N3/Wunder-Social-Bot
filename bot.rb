require 'net/http'
require 'uri'
require 'json'
require 'date'
require 'logger'
require 'fileutils'
require 'terminal-table'
require 'colorize'

# Setup logging
@logger = Logger.new(STDOUT)
@logger.level = Logger::INFO

FileUtils.mkdir_p(File.dirname('wunderclaim.log')) unless File.exist?('wunderclaim.log')
@log_file = Logger.new('wunderclaim.log')
@log_file.level = Logger::INFO

# Banner
BANNER = <<~BANNER
  ╔══════════════════════════════════════════════╗
  ║      🌟 WunderClaim Bot - Username Claim     ║
  ║  Automate username claiming on wunder.social!║
  ║  Developed by: https://t.me/sentineldiscus   ║
  ╚══════════════════════════════════════════════╝
BANNER

# Generator kata bahasa Inggris sederhana
VOWELS = %w[a e i o u]
CONSONANTS = %w[b c d f g h j k l m n p q r s t v w x y z]

def generate_english_word(min_length = 7)
  word = ''
  length = rand(min_length..10)
  use_vowel = [true, false].sample

  length.times do
    word += use_vowel ? VOWELS.sample : CONSONANTS.sample
    use_vowel = !use_vowel
  end
  word
end

def generate_random_date
  start_date = Date.new(1970, 1, 1)
  end_date = Date.new(2005, 12, 31)
  random_days = rand((end_date - start_date).to_i)
  (start_date + random_days).strftime('%Y-%m-%d')
end

def get_guerrilla_email
  uri = URI.parse('https://api.guerrillamail.com/ajax.php?f=get_email_address')
  response = Net::HTTP.get_response(uri)

  if response.is_a?(Net::HTTPSuccess)
    data = JSON.parse(response.body)
    email = data['email_addr']
    sid_token = data['sid_token']
    @logger.info "Berhasil mendapatkan email: #{email}".green
    [email, sid_token]
  else
    @logger.error "Gagal mendapatkan email dari Guerrilla Mail: #{response.code}".red
    [nil, nil]
  end
rescue StandardError => e
  @logger.error "Error saat menghubungi Guerrilla Mail API: #{e.message}".red
  [nil, nil]
end

def submit_claim(payload)
  url = URI.parse('https://www.wunder.social/api/submit-claim-username')
  headers = {
    'Content-Type' => 'application/json',
    'Accept' => '*/*',
    'Accept-Language' => 'en-ID,en;q=0.9,ja-ID;q=0.8,ja;q=0.7,id-ID;q=0.6,id;q=0.5,en-GB;q=0.4,en-US;q=0.3',
    'Origin' => 'https://www.wunder.social',
    'Referer' => 'https://www.wunder.social/claim-your-username',
    'User-Agent' => 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.0.0 Safari/537.36'
  }

  # Simpan data ke file json dengan append
  filename = 'data.json'
  data_list = []

  if File.exist?(filename)
    begin
      data_list = JSON.parse(File.read(filename))
      data_list = [data_list] unless data_list.is_a?(Array)
    rescue JSON::ParserError, StandardError => e
      @logger.error "Error membaca file #{filename}: #{e.message}".red
      data_list = []
    end
  end

  data_list << payload

  begin
    File.write(filename, JSON.pretty_generate(data_list))
    @logger.info "Data disimpan ke #{filename}".green
  rescue StandardError => e
    @logger.error "Gagal menyimpan data ke file: #{e.message}".red
  end

  # Tampilkan data dalam tabel
  table = Terminal::Table.new do |t|
    t.title = 'Data Claim'
    t.headings = ['Field', 'Value']
    t.rows = [
      ['Tanggal Lahir', payload['dateOfBirth']],
      ['Nama Depan', payload['firstName']],
      ['Nama Belakang', payload['lastName']],
      ['Handle Sosial', payload['socialHandles']],
      ['Username', payload['username']],
      ['Email', payload['email']]
    ]
  end
  puts table

  # Kirim POST request
  begin
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.read_timeout = 10
    request = Net::HTTP::Post.new(url.request_uri, headers)
    request.body = payload.to_json
    response = http.request(request)

    if response.code == '200'
      begin
        parsed_response = JSON.parse(response.body)
        @logger.info "Success! #{parsed_response['inlineMessage']}".green
      rescue JSON::ParserError => e
        @logger.error "Success, but response is not valid JSON: #{response.body}".red
      end
    else
      @logger.error "Failed with status code: #{response.code}".red
      @logger.error "Response: #{response.body}".red
    end
  rescue StandardError => e
    @logger.error "An error occurred: #{e.message}".red
  end
end

def manual_mode
  puts 'Mode Manual: Masukkan data Anda secara manual'.yellow.bold
  print 'Tanggal Lahir (format: YYYY-MM-DD, contoh: 1945-08-17): '
  date_of_birth = gets.chomp
  print 'Nama Depan: '
  first_name = gets.chomp
  print 'Nama Belakang: '
  last_name = gets.chomp
  print 'Handle Sosial Media: '
  social_handles = gets.chomp
  print 'Username yang diinginkan: '
  username = gets.chomp

  email, _ = get_guerrilla_email
  unless email
    puts 'Tidak dapat melanjutkan karena gagal mendapatkan email sementara.'.red.bold
    return
  end

  payload = {
    'dateOfBirth' => date_of_birth,
    'email' => email,
    'firstName' => first_name,
    'followersRange' => '',
    'hiddenField' => '',
    'lastName' => last_name,
    'postRegularly' => false,
    'socialHandles' => social_handles,
    'termsAccepted' => true,
    'username' => username
  }
  submit_claim(payload)
end

def random_mode_task
  email, _ = get_guerrilla_email
  unless email
    @logger.error 'Gagal mendapatkan email sementara.'.red
    return
  end

  date_of_birth = generate_random_date
  first_name = generate_english_word
  last_name = generate_english_word
  social_handles = "#{generate_english_word}.#{generate_english_word[0..2]}"
  username = "#{generate_english_word}#{rand(10..99)}"

  payload = {
    'dateOfBirth' => date_of_birth,
    'email' => email,
    'firstName' => first_name,
    'followersRange' => '',
    'hiddenField' => '',
    'lastName' => last_name,
    'postRegularly' => false,
    'socialHandles' => social_handles,
    'termsAccepted' => true,
    'username' => username
  }
  submit_claim(payload)
end

def random_mode
  puts 'Mode Random: Data akan di-generate secara otomatis'.yellow.bold
  print 'Masukkan jumlah claim yang diinginkan: '
  num_requests = gets.chomp.to_i

  if num_requests <= 0
    puts 'Jumlah harus lebih dari 0!'.red.bold
    return
  end

  puts "Memulai #{num_requests} claim secara paralel...".green.bold
  threads = []
  [num_requests, 10].min.times do
    threads << Thread.new { random_mode_task }
  end
  threads.each(&:join)
end

def main
  puts BANNER
  puts 'Pilih mode:'
  puts '1. Manual (input data sendiri)'
  puts '2. Random (data otomatis)'
  print 'Masukkan pilihan (1 atau 2): '
  choice = gets.chomp

  case choice
  when '1'
    manual_mode
  when '2'
    random_mode
  else
    puts 'Pilihan tidak valid. Harap masukkan 1 atau 2.'.red.bold
  end
end

main if $PROGRAM_NAME == __FILE__
