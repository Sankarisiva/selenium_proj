require  'rspec'
require 'selenium-webdriver'
require 'pry'

describe 'test' do
  before(:all) do
    @driver = Selenium::WebDriver.for :chrome
    @wait = Selenium::WebDriver::Wait.new(timeout: 5)
  end

  it 'test' do
    @driver.get 'https://www.gmail.com'
    binding.pry
    window_handles = @driver.window_handles
    @driver.switch_to.window window_handles[1]
    Selenium::WebDriver.for :chrome
    Selenium::WebDriver.for :chrome
    binding.pry
  end
end


# driver = Selenium::WebDriver.for :chrome
# driver.get 'https://www.gmail.com'
# driver.manage.new_window(:window)
# driver.switch_to.window(driver.window_handles.last)