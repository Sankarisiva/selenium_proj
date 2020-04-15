require 'selenium-webdriver'
require 'pry'
require 'rspec'


describe 'Screenshot windows' do
	before(:all) do
		@driver = Selenium::WebDriver.for :chrome
		@wait = Selenium::WebDriver::Wait.new(:timeout => 5)
	end

	after(:all) do
		@driver.quit
	end

	it 'Verify user should be able to navigate to MSN web page' do
		@driver.get 'https://www.msn.com/en-in'
		expect(@driver.find_element(:link_text,'msn').displayed?).to eq true
	end

	it 'Verify user should be able to open tab' do
		expect(open_tab('Outlook.com','Online Games','Facebook','Office','Twitter','OneDrive','Booking.com')).to eq true
	end

	it 'Verify user should be able to print page titles in the given order' do
		expect(print_page_title('Facebook','Outlook – free personal','Office','Twitter','Games','OneDrive','Booking.com')).to eq true
	end

	it 'Verify user should be able to print homepage' do
		expect(print_page_title('MSN')).to eq true
	end

	def open_tab(*tab_names)
		elements = @driver.find_elements(:xpath,"//ul[@role='menubar']/li/a/h3")
		tab_names.each do |tab_name|
			elements.each do |element|
				if(element.text.include? tab_name)
					@driver.find_element(:xpath,"//h3[text()='"+tab_name+"']").click
					@window_handles = @driver.window_handles
					@driver.switch_to.window @window_handles[0]
					break
				end
			end
		end
		@window_handles.size == (tab_names.size+1)
	end

	def print_page_title(*page_titles)
		screenshot_count = 0
		window_handles = @driver.window_handles
		count = 0
		page_titles.each do |page_title|
			window_handles.each do |window_handle|
				@driver.manage.timeouts.implicit_wait = 5
				if(@driver.title.include? page_title)
					@driver.save_screenshot("#{Pathname.pwd}/screenshots/#{Time.new.strftime("%Y-%m-%d-%H-%M-%S")}.png")
					screenshot_count = screenshot_count+1
					break
				else
					count = count + 1
					@driver.switch_to.window(@driver.window_handles[count])
				end
			end
			count = 0
			@driver.switch_to.window(@driver.window_handles[0])
		end
		screenshot_count ==  page_titles.size

	end
end


