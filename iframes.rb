require 'selenium-webdriver'
require 'pry'
require 'rspec'

describe 'iframes' do
	before(:all) do
		@driver = Selenium::WebDriver.for :chrome
		@wait = Selenium::WebDriver::Wait.new(timeout: 25)
	end

	after(:all) do
		@driver.quit
	end

	it 'Verify user should be able to get into URL' do
		@driver.get 'https://www.msn.com/en-in'
		expect(@driver.find_element(:link_text,'msn').displayed?).to eq true
	end

	it 'Verify user should be able to get total number of iframes' do
		@driver.execute_script("window.scrollTo(0, document.body.scrollHeight)")
		expect(@wait.until {@driver.find_element(:xpath,"//iframe[contains(@src,'facebook')]").displayed?}).to eq true
		expect(@wait.until { @driver.find_element(:xpath,"//iframe[contains(@src,'twitter')]").displayed?}).to eq true
		puts 'Total number of iframes'
		puts @driver.find_elements(:xpath,"//iframe").size
	end

	it 'Verify user should be able to print content of facebook' do
		expect(@driver.find_element(:xpath,"//iframe[contains(@src,'facebook')]").displayed?).to eq true
		@driver.switch_to.frame(@driver.find_element(:xpath,"//iframe[contains(@src,'facebook')]"))
		sleep 5
		@driver.find_element(:xpath,"html//span[@class='_8f1i']").click
		@driver.find_element(:xpath,"html//span[@class='_8f1i']").click
		@driver.switch_to.window(@driver.window_handles.last)
		expect(@driver.title.include? 'Facebook').to eq true
		print_page_content
		@driver.switch_to.window(@driver.window_handles.first)
	end

	it 'Verify user should be able to print content of Twitter' do
		@driver.switch_to.frame(@driver.find_element(:xpath,"//iframe[contains(@src,'twitter')]"))
		@driver.find_element(:xpath,"html//span[@class='label']").click
		@driver.switch_to.window(@driver.window_handles.last)
		expect(@driver.title.include? 'Twitter').to eq true
		print_page_content
	end

	it 'Verify user should be able to switch back to main page and click on main page logo' do
		@driver.switch_to.window(@driver.window_handles.first)
		@driver.execute_script("window.scrollTop")
		@driver.find_element(:xpath,"//a[@class='logo']").click
		element = @driver.find_element(:xpath,"//span[text()='msn']")
		expect(@wait.until{element.displayed?}).to eq true
	end

	def print_page_content
		element = @driver.find_element(:tag_name,'body')
		puts element.text.split("\n")
		puts "---------"
	end
end
