require 'selenium-webdriver'
require 'pry'
require 'rspec'

describe 'currency converter' do

  before(:all) do
		@driver = Selenium::WebDriver.for :chrome
		@wait = Selenium::WebDriver::Wait.new(timeout: 4)
	end

	after(:all) do
		@driver.quit
	end

	it 'Verify user should be able to navigate to MSN web page' do
		@driver.get 'https://www.msn.com/en-in'
		expect(@driver.find_element(:link_text,'msn').displayed?).to eq true
	end

	it 'Verify user should be able to click money link' do
		@driver.find_element(:link_text,'Money').click
		expect(@driver.find_element(:xpath,"//a[text()='money']").displayed?).to eq true
	end

	it 'Verify user should be able to navigate to currency converter' do
		@driver.find_element(:class,'rightarrow').click
		element = @driver.find_element(:link_text,'Currency Converter')
		if @wait.until {element.displayed?}
			element.click
		end
		expect(@driver.find_element(:xpath,"//span[text()='Currency Converter']").displayed?).to eq true
	end

	it 'Verify user should be able to select from_currency_value from dropdown' do
		select_value("British Pound","from")
		select_value("Indian Rupee","to")
		element = @driver.find_element(:id,'totxtbx')
		$first_val = (element.attribute("value")).to_f
		expect(verify_currency_code("GBP","INR")).to eq true
	end

	it 'Select user should be able to select to_currency_value from dropdown' do
		select_value("United States Dollar","from")
		select_value("Indian Rupee","to")
		element = @driver.find_element(:id,'totxtbx')
		$second_val = (element.attribute("value")).to_f
		expect(verify_currency_code("USD","INR")).to eq true
	end

	it 'User should be able to perform mathematical operations' do
		puts ($first_val-$second_val).round(2)
	end

  def verify_currency_code(from_currency_code,to_currency_code)
		element= @driver.find_element(:id,"cc-chartheading").text.split("/")
		from_currency_code == element[0].strip and to_currency_code == element[1].strip
	end

	def select_value(currency,dropdown_type)
		if(dropdown_type == 'from')
			id = 'frmmenu'
		elsif(dropdown_type == 'to')
			id = 'tomenu'
		end
		from_elements = @driver.find_elements(:xpath,"//*[@id='#{id}']/option")
		from_elements.each do |element|
			if(element.text == currency)
				element.click
			end
		end
	end
end
