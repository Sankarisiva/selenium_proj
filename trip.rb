require 'selenium-webdriver'
require 'pry'
require 'rspec'

describe 'Trip' do
  before(:all) do
    require 'selenium-webdriver'
    chrome_options = Selenium::WebDriver::Chrome::Options.new
    chrome_options.add_argument("--disable-notifications")
    @driver = Selenium::WebDriver.for(:chrome, options: chrome_options)
    @wait = Selenium::WebDriver::Wait.new(:timeout => 15)
  end

  after(:all) do
    @driver.quit
  end

  it 'Verify user should be able to navigate to given URL' do
    @driver.get 'https://www.cleartrip.com/'
    expect(@driver.find_element(:xpath,"//span[@title='Cleartrip ']").displayed?).to eq true
  end

  it 'Verify user should be able to select trip type' do
    expect(select_trip_type("OneWay")=="true")
  end

  it 'Verify user should be able to select from_city' do
    sleep 5
    @driver.find_element(:id,'FromTag').click
    @driver.find_element(:id,'FromTag').send_keys 'Chennai'
    @wait.until { @driver.find_element(:xpath,"//a[contains(text(),'Chennai,')]").displayed? }
    @driver.find_element(:xpath,"//a[contains(text(),'Chennai,')]").click
    expect( @driver.execute_script("return document.getElementById('FromTag').value").include? 'Chennai').to eq true
  end

  it 'Verify user should be able to select to_city' do
    @driver.find_element(:id,'ToTag').click
    @driver.find_element(:id,'ToTag').send_keys 'Mumbai'
    @wait.until { @driver.find_element(:xpath,"//a[contains(text(),'Mumbai,')]").displayed? }
    @driver.find_element(:xpath,"//a[contains(text(),'Mumbai,')]").click
    expect( @driver.execute_script("return document.getElementById('ToTag').value").include? 'Mumbai').to eq true
  end

  it 'Verify user should be able to select departure_date' do
    select_departure_date
    @driver.find_element(:xpath,"//i[contains(@class,'datePicker')]").click
    expect(@driver.execute_script("return document.getElementById('DepartDate').value").include? @date).to eq true
    expect(@driver.execute_script("return document.getElementById('DepartDate').value").include? @month).to eq true
    expect(@driver.execute_script("return document.getElementById('DepartDate').value").include? @year).to eq true
  end

  it 'Verify user should be able to select adults/infants/children' do
    @driver.find_element(:xpath,"//h1[contains(text(),'Search')]").click
    expect(select_from_dropdown(5,'Adults')).to eq true
    expect(select_from_dropdown(3,'Childrens')).to eq true
    expect(select_from_dropdown(1,'Infants')).to eq true
    @driver.find_element(:id,'SearchBtn').click
    @wait.until { @driver.find_element(:xpath,"//a[text()='Airline']").displayed?}
    expect(@driver.find_element(:xpath,"//a[text()='Airline']").displayed?).to eq true
    select_rate
    expect(select_stops("0 stop",'0')).to eq true
    select_departure_time("Early Morning")
    book_flight(3)
  end

  it 'Take screenshots' do
    sleep 5
    element = @driver.find_element(:xpath,"//h2[text()=' Itinerary']")
    if @wait.until { element.displayed? }
      @driver.save_screenshot("#{Pathname.pwd}/screenshots/#{Time.new.strftime("%Y-%m-%d-%H-%M-%S")}.png")
    end
  end

  def select_rate
    element = @driver.find_element(:xpath,"//a[@class='rangeHandle']")
    @wait.until{element.displayed?}
    @driver.action.drag_and_drop_by(element,-30,0).perform
  end

  def select_trip_type(trip_type)
    @driver.find_element(:id,""+trip_type+"").click
    element =  @driver.find_element(:xpath,"//input[@id='"+trip_type+"']")
    return element.attribute("checked")
  end

  def get_current_date
    t = Date.today
    t = t+30
    t =t.to_s
    t = t.split("-")
    @date = t[2].to_i.to_s
    @month = Date.today.next_month.strftime("%B")
    @year = t[0]
  end

  def select_departure_date
    get_current_date
    while(true)
      get_months = @driver.find_elements(:xpath,"//span[contains(@class,'datepicker-month')]")
      if get_months[0].text == @month
        index = 1
        break
      elsif get_months[1].text == @month
        index = 2
        break
      else
        @driver.find_element(:class,'nextMonth ').click
      end
    end

    get_dates = @driver.find_elements(:xpath,"//*[@id='ui-datepicker-div']/div[#{index}]/table/tbody/tr/td/a")
    get_dates.each do |date|
      if(date.text == @date)
        date.click
      end
    end
  end

  def select_from_dropdown(count,value)
    @driver.find_element(:xpath, "//select[@id='"+value+"']").click
    elements = @driver.find_elements(:xpath,"//select[@id='"+value+"']/option")
    elements.each do |element|
      if(element.text == count.to_s)
        puts element.text
        element.click
        break
      end
    end
    @driver.execute_script("return document.getElementById('"+value+"').value") ==  count.to_s
  end

  def select_stops(stop,stop_id)
    return true if @driver.find_element(:xpath,"//a[contains(text(),'Non-stop')]//parent::li[contains(@class,'current')]").displayed?
    elements = @driver.find_elements(:xpath,"//input[@id='1_1_"+stop+"']//parent::li/parent::ul/li")
    elements.each do |element|
      if(element.text == stop)
        element.click
        break
      end
    end
    @driver.execute_script("return document.getElementById('1_1_"+stop+"').value") == stop_id
  end

  def select_departure_time(departure_time)
    elements = @driver.find_elements(:xpath,"//nav[@class='departureTime']/ul/li")
    elements.each do |element|
      puts element.text
      if(element.text.include? departure_time)
        element.click
        break
      end
    end
  end

  def book_flight(flight_count)
    count = 0
    elements = @driver.find_elements(:xpath,"//button[@type='submit']//parent::td")
    elements.each do |element|
      if(count== flight_count-1)
        element.click
        break
      end
      count = count + 1
    end
  end
end

# require 'selenium-webdriver'
# chrome_options = Selenium::WebDriver::Chrome::Options.new
# chrome_options.add_argument("--disable-notifications")
# @driver = Selenium::WebDriver.for(:chrome, options: chrome_options)
#  @driver.get 'https://www.cleartrip.com/'