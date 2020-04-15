require 'selenium-webdriver'
require 'rspec'
require 'pry'

describe 'Actions' do
  before(:all) do
    @driver = Selenium::WebDriver.for :chrome
    @wait = Selenium::WebDriver::Wait.new(:timeout => 15)
  end

  after(:all) do
    @driver.quit
  end

  it 'move_to_element example' do
    @driver.get 'https://www.amazon.com'
    @driver.action.move_to(@driver.find_element(:xpath,"//span[@class='nav-line-2 ']")).perform
  end

  it 'make my trip - move to example and printing dynamic placeholders' do
    @driver.execute_script("window.open()")
    @driver.switch_to.window (@driver.window_handles.last)
    @driver.get 'https://makemytrip.com'
    @driver.action.move_to(@driver.find_element(:xpath,"//span[@class='darkGreyText']")).perform
    elements = @driver.find_elements(:xpath,"//a[contains(@data-cy,'submenu')]")
    elements.each do |element|
      if(element.text == 'Blog')
        element.click
        break
      end
    end
    sleep 10
    @driver.switch_to.window(@driver.window_handles.last)
    print_dynamic_placeholder
  end

  it 'double click and alert handling' do
    @driver.get 'https://www.testandquiz.com/selenium/testing.html'
    element = @driver.find_element(:id,'dblClkBtn')
    @driver.action.double_click(element).perform
    @driver.switch_to.alert.accept
  end

  it 'drag and drop example' do
    @driver.execute_script("window.open()")
    @driver.switch_to.window (@driver.window_handles.last)
    @driver.get 'https://jqueryui.com/droppable/'
    @driver.switch_to.frame(0)
    @driver.find_element(:xpath,"//div[@id='draggable']/p").text
    source =  @driver.find_element(:id,"draggable")
    target = @driver.find_element(:id,"droppable")
    #@driver.action.click_and_hold(source).move_to(target).release.perform
    @driver.action.drag_and_drop(source,target).perform
  end

  def print_dynamic_placeholder
    @driver.find_element(:xpath,"//a[contains(@class,'continue_btn')]").click
    element = @driver.find_element(:id,'search_box_default_value')
    for i in 0..5
      puts element.attribute("value")
      sleep 3
    end
  end
end