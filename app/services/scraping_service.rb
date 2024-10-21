class ScrapingService
  require 'nokogiri'
  require 'selenium-webdriver'

  SELENIUM_WAIT_TIMEOUT = 90

  def self.scrape_data(url)
    begin
      driver = initialize_driver
      load_page(driver, url)

      sleep(5)
      document = Nokogiri::HTML(driver.page_source)

      brand = document.at_css('h1#VehicleBasicInformationTitle').text.split.first
      model = document.at_css('h1#VehicleBasicInformationTitle strong').text
      price = document.css('#vehicleSendProposalPrice').text

      { brand: brand, model: model, price: price }
    rescue Selenium::WebDriver::Error::TimeoutError => e
      handle_error(e)
    rescue Selenium::WebDriver::Error::NoSuchElementError => e
      handle_error(e)
    rescue => e
      handle_error(e)
    ensure
      driver&.quit
    end
  end

  private

  def self.initialize_driver
    options = Selenium::WebDriver::Firefox::Options.new
    options.add_argument('--disable-blink-features=AutomationControlled')
    options.add_argument('--headless')
    options.add_argument('--no-sandbox')
    options.add_argument('--disable-dev-shm-usage')

    profile = Selenium::WebDriver::Firefox::Profile.new
    profile['general.useragent.override'] = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36"
    profile['dom.webdriver.enabled'] = false
    profile['useAutomationExtension'] = false

    options.profile = profile
    Selenium::WebDriver.for(:firefox, options: options)
  end

  def self.load_page(driver, url)
    delay = rand(1..3)
    sleep(delay)
    driver.navigate.to(url)
    driver.execute_script('window.scrollTo(0, document.body.scrollHeight);')
    wait = Selenium::WebDriver::Wait.new(timeout: SELENIUM_WAIT_TIMEOUT)
    wait.until { driver.find_element(css: 'h1#VehicleBasicInformationTitle') }
  end

  def self.handle_error(error)
    puts "Error: #{error.message}"
  end
  
end

