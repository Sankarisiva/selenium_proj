require 'rspec'
require 'selenium-webdriver'
require 'pry'

describe 'Google play' do

  before(:all) do
    @driver = Selenium::WebDriver.for :chrome
    @wait = Selenium::WebDriver::Wait.new(:timeout => 25)
  end

  after(:all) do
    @driver.quit
  end

  it 'Verify user should be able to get into URL' do
    @driver.get 'https://www.msn.com/en-in'
    expect(@driver.find_element(:link_text,'msn').displayed?).to eq true
  end

  it 'Verify user should be able to click on google play' do
    @driver.execute_script("window.scrollTo(0, document.body.scrollHeight)")
    @driver.find_element(:xpath,"//img[contains(@src,'play.google')]").click
    expect(@wait.until{@driver.find_element(:xpath,"//span[text()='Microsoft News']").displayed?}).to eq true
  end

  it 'Handle pop up' do
    @driver.switch_to.window(@driver.window_handles.last)
    @driver.find_element(:css,'.Bovvxc').click
    @driver.find_element(:xpath,"//span[contains(text(),'continue')]//following-sibling::div/div/button[text()='Cancel']").click
    expect(@driver.find_element(:xpath,"//span[text()='Microsoft News']").displayed?).to eq true
  end

  it 'Clicking on view more' do
    @driver.find_element(:xpath,"//div[@class='W9yFB']/a").click
    expect(@wait.until{@driver.find_element(:xpath,"//h2[text()='Similar apps']").displayed?}).to eq true
  end

  it 'Print all the app names' do
    @driver.execute_script("window.scrollTo(0, document.body.scrollHeight)")
    print_list("//div[@class='WsMG1c nnK0zc']")
  end

  it '' do
    @driver.switch_to.window(@driver.window_handles.first)
    expect(@driver.find_element(:xpath,"//span[text()='msn']").displayed?).to eq true
    @driver.find_element(:xpath,"//img[contains(@src,'linkmaker')]").click
    @driver.switch_to.window(@driver.window_handles.last)
    @driver.execute_script("window.scrollTo(0, document.body.scrollHeight)")
    if @wait.until{@driver.find_element(:id,'ember379').displayed?}
      @driver.find_element(:id,'ember379').click
    end
    print_list("//div[@class='l-row']/a/div/div/div")
  end

  it '' do
    @driver.execute_script("window.scrollTop")
    @driver.find_element(:xpath,"//a[text()='Microsoft News']").click
    @driver.switch_to.window(@driver.window_handles.last)
    @driver.find_element(:id,"ember1036").click
    @driver.execute_script("window.scrollTo(0, document.body.scrollHeight)")
    print_list("//div[@class='we-lockup__copy']/div/div")
  end
end

def print_list(xpath_query)
  sleep 7
  elements = @driver.find_elements(:xpath,xpath_query)
  elements.each do |element|
    puts element.text
  end
  puts '----------------------------------------------'
end
