require 'selenium-webdriver'
require 'pry'
require 'rspec'

describe 'IRCTC' do

  before(:all) do
    @driver = Selenium::WebDriver.for :chrome
    @wait = Selenium::WebDriver::Wait.new(:timeout => 20)
  end

  after(:all) do
    @driver.quit
  end

  it 'Verify user should be able to get into URL' do
    @driver.get 'https://www.irctc.co.in/nget/train-search'
    binding.pry
    element = @driver.find_element(:xpath,"//button[text()='Ok']")
    if @wait.until { element.displayed? }
      element.click
    end
    expect(@driver.find_element(:xpath,"//span[contains(text(),'YOUR TICKET')]").displayed?).to eq true
  end

  it 'Verify user should be able to view charts-vacancy' do
    @driver.manage.window.maximize
    @driver.find_element(:xpath,"//label[contains(text(),'CHARTS')]").click
    @driver.switch_to.window(@driver.window_handles.last)
    expect(@driver.find_element(:xpath,"//h6[contains(text(),'RESERVATION')]").displayed?).to eq true
  end

  it 'Verify user should be able to give input' do
    element = @driver.find_element(:xpath,"//div[contains(text(),'Train')]")
    element.click
    binding.pry
    @driver.find_element(:xpath,"//input[@id='react-select-4-input']").send_keys '12635 - VAIGAI EXP'
    @driver.find_element(:xpath,"//input[@id='react-select-4-input']").send_keys :enter
    expect(@driver.find_element(:xpath,"//div[@class='css-xp4uvy']").text == '12635 - VAIGAI EXP').to eq true
  end

  it 'Verify user should be able to get the chart details, print and close' do
    @driver.manage.timeouts.implicit_wait = 2
    @driver.find_element(:xpath,"//label[@class='jss406 jss179']//div//following-sibling::span/div").click
    elements = @driver.find_elements(:xpath,"//tr[contains(@class,'jss533')]")
    elements.each do |element|
      puts element.text
    end
    @driver.find_element(:xpath,"//button[contains(@class,'jss373')]").click
  end

  it 'Verify user should be able to print list of boarding stations' do
    @driver.find_element(:xpath,"//span[@class='css-d8oujb']//parent::div/div").click
    elements = @driver.find_elements(:xpath,"//div[@class='css-11unzgr']/div")
    elements.each do |element|
      puts element.text
    end
  end

  it 'Verify user should be able to select from_station' do
    @driver.switch_to.window(@driver.window_handles.first)
    xpath = "//ul[contains(@class,'ui-autocomplete-items')]/li"
    select_train('From*','EGMORE',xpath)
    select_train('To*','MADURAI JN',xpath)
    @driver.find_element(:xpath,"//span[contains(@class,'dropdown-trigger')]").click
    xpath_query = "//ul[contains(@class,'ui-dropdown-items')]/li"
    select_from_dropdown(xpath_query, 'Sleeper')
    @driver.find_element(:xpath,"//button[@type='submit' and @label = 'Find Trains']").click
    puts @driver.find_element(:xpath,"//div[@class='ui-growl-message']/p").text
    element = @driver.find_element(:xpath,"//div[contains(@class,'text-center station')]/span")
    expect(verify_from_to_station(element,'CHENNAI','MADURAI')).to eq true
  end

  it 'Verify whether the selected journey date is correct' do
    @driver.find_element(:xpath,"//input[contains(@placeholder,'Journey')]").click
    select_date('July','2020','25')
    @driver.find_element(:xpath,"//button[@type='submit' and @label = 'Find Trains']").click
    element = @driver.find_element(:class,'t_2_1')
    @wait.until { element.displayed? }
    expect(element.text == '25 Jul').to eq true
  end

  it 'Verify from_station and to_station and print the list of trains' do
    print_train_list
    element = @driver.find_element(:xpath,"//span[@class='t_1']")
    @wait.until { element.displayed? }
    expect(verify_from_to_station(element,'CHENNAI','MADURAI')).to eq true
  end

  it 'Print the availability of train' do
    elements = @driver.find_elements(:xpath,"//div[contains(@class,'table-responsive')]/table/tbody/tr")
    elements.each do |element|
      puts element.text
    end
  end

  def select_train(place,city,xpath)
    element = @driver.find_element(:xpath,"//input[@placeholder='"+place+"']")
    element.click
    element.send_keys city
    select_from_dropdown(xpath,city)
  end

  def select_from_dropdown(xpath,place)
    @driver.manage.timeouts.implicit_wait = 5
    elements =  @driver.find_elements(:xpath, xpath)
    elements.each do |element|
      if(element.text.include? place)
        element.click
        break
      end
    end
  end

  def select_date(reqd_month, reqd_year,date)
    while(true)
      month = @driver.find_element(:xpath,"//span[contains(@class,'ui-datepicker-month')]").text
      year = @driver.find_element(:xpath,"//span[contains(@class,'ui-datepicker-year')]").text
      if(month == reqd_month and year == reqd_year)
        break
      else
        @driver.find_element(:xpath,"//span[contains(@class,'fa-angle-right')]").click
      end
    end

    elements = @driver.find_elements(:xpath,"//tbody[@class='ng-tns-c12-5']/tr/td/a")
    elements.each do |element|
      if(element.text == date)
        puts element.text
        element.click
        break
      end
    end
  end

  def print_train_list
    count = 0
    elements = @driver.find_elements(:xpath,"//a[contains(@id,'T_')]/span")
    elements.each do |element|
      if element.text.include? 'KANYAKUMARI'
        flag = 0
        puts element.text
        check_index =  @driver.find_elements(:id,"check-availability")
        check_index.each do |index|
          flag = flag + 1
          if(flag == count+1)
            @driver.execute_script("arguments[0].scrollIntoView(true);",index)
            @driver.manage.timeouts.implicit_wait = 4
            index.click
            break
          end
        end
      end
      count = count + 1
    end
  end

  def verify_from_to_station(element,from_station,to_station)
    element.text.include? from_station and element.text.include? to_station
  end
end

temp_name = '12345'
names = @driver.find_element(:xpath,"//div[@class='css-15k3avv']").text.split("/n")
names.each do |name|
  if(name.include? temp_name)
    puts "train name is present"
    break
  end
end

