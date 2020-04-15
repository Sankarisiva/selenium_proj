require 'rspec'
require 'selenium-webdriver'
require 'pry'

describe 'Sample spec' do

  before(:all)  do
    @driver = Selenium::WebDriver.for :chrome
    @wait = Selenium::WebDriver::Wait.new(:timeout => 5)
  end

  after(:all) do
    @driver.quit
  end

  it 'prints page title' do
    @driver.get 'https://www.testandquiz.com/selenium/testing.html'
    expect(@driver.title.include? "Sample").to eq true
    binding.pry
    @driver.save_screenshot("#{Pathname.pwd}/screenshots/#{Time.new.strftime("%Y-%m-%d-%H-%M-%S")}.png")
  end

  it 'radio button and check box' do
    @driver.find_element(:id,'female').click
    @driver.find_element(:class,'Automation').click
  end

  it 'double click and alert, accept alert' do
    element = @driver.find_element(:id,'dblClkBtn')
    @driver.action.double_click(element).perform
    sleep 2
    puts @driver.switch_to.alert.text
    @driver.switch_to.alert.accept
  end
end