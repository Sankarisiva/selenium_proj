require 'selenium-webdriver'
require 'pry'
require 'rspec'

describe 'Click element from dropdown' do

	before(:all) do
		@driver = Selenium::WebDriver.for :chrome
		@wait = Selenium::WebDriver::Wait.new(timeout: 4)
	end

	after(:all) do
		@driver.quit
	end

  it 'Verify user should be able to navigate to URL' do
		@driver.get 'https://www.msn.com/en-in'
		expect(@driver.find_element(:link_text,'msn').displayed?).to eq true
	end

	it 'Verify user should be able to search text' do
		@driver.find_element(:id,'q').send_keys 'Freshworks'
		expect(verify_dropdown_values).to eq true
	end

	it 'Verify user should be able to navigate to page by clicking image in the dropdown' do
		element = @driver.find_element(:xpath, "//div[contains(@class,'cico')]/img")
		if @wait.until { element.displayed? }
			element.click
		end
		window_handles = @driver.window_handles
		@driver.switch_to.window window_handles[1]
		expect(@driver.find_element(:link_text,'Freshworks').displayed?).to eq true
	end

	it 'Print all the links' do
		print_all_links
	end

	def verify_dropdown_values
		count = 0
		@driver.find_element(:id,'q').click
		@driver.manage.timeouts.implicit_wait = 2
		elements  = @driver.find_elements(:class,"sa_tm_text")
		elements.each do |element|
			if not(element.text.include? "freshworks")
				count = 0
				return false
			else
				count = count + 1
				puts element.text
			end
		end
		count == elements.size
	end

	def print_all_links
		elements = @driver.find_elements(:xpath,"//body//a")
		elements.each do |element|
			if(element.text !='' and element.attribute("href")!='javascript:void(0);' and element.attribute("href")!='javascript:')
				puts element.text
				puts element.attribute("href")
				puts "------------"
			end
		end
	end
end
