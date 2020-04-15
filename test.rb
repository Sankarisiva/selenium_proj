require 'rspec'
require 'selenium-webdriver'
require 'pry'

describe 'describe 1' do
  val = 1
  $g = 3
  before(:all) do
    @driver = Selenium::WebDriver.for :chrome
    @wait = Selenium::WebDriver::Wait.new(timeout: 4)
    @before = 0
  end

  after(:all) do
    @driver.quit
  end
  it 'test 1' do
    puts 'test 1'

    @inst = 10000000
  end

  it 'test 2' do
    puts 'test 2'
    puts val
    val = 2
    puts val
    puts @inst
    binding.pry
    puts '-----'
    puts @before
    @before = 'before'
    puts @before
  end
end
describe 'describe 2' do
  it 'test 1' do
    puts 'test 1'
    puts $g
    binding.pry
  end

  it 'test 2' do
    puts 'test 2'
  end
end

