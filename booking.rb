require 'rspec'
require 'selenium-webdriver'
require 'pry'

describe 'Booking' do
  before(:all) do
    @driver = Selenium::WebDriver.for :chrome
    @wait = Selenium::WebDriver::Wait.new(:timeout => 15)
  end

  after(:all) do
    @driver.quit
  end

  it 'Verify user should be able to get into URL' do
    @driver.get 'https://www.msn.com/en-in'
    expect(@driver.find_element(:link_text,'msn').displayed?).to eq true
  end

  it 'Verify user should be able to click on skype' do
    binding.pry
    open_tab('Booking.com')
    @driver.switch_to.window(@driver.window_handles.last)
    expect(@driver.find_element(:xpath,"//img[contains(@id,'logo_no_globe_new_logo')]").displayed?).to eq true
  end

  it 'Verify user should be able to send keys in the input value' do
    expect(@driver.find_element(:xpath,"//input[@placeholder='Where are you going?']").displayed?).to eq true
    @driver.find_element(:id,'ss').send_keys('Che')
  end

  it 'Print all Browse by property type' do
    @driver.switch_to.window(@driver.window_handles.last)
    select_city('Chennai')
    select_adult_children_room('Adults')

    #//button[contains(@aria-label,'Increase number of Adults')]
  end

  def select_adult_children_room(type)
    @driver.find_element(:id,'xp__guests__toggle').click
    element = "//button[contains(@aria-label,'Increase number of "+type+"')]"
    binding.pry
  end

  def open_tab(tab_name)
   # @driver.find_element(:id,'ss').click
    elements = @driver.find_elements(:xpath,"//ul[@role='menubar']/li/a/h3")
    elements.each do |element|
      if(element.text.include? tab_name)
        @driver.find_element(:xpath,"//h3[text()='"+tab_name+"']").click
        break
      end
    end
  end

  def select_city(city_name)
    elements = @driver.find_elements(:xpath,"//ul[@role='listbox']/li")
    elements.each do |element|
      if(element.text.include? city_name)
        element.click
        break
      end
    end
  end
end