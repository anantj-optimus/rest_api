require 'yaml'
fn = File.dirname(File.expand_path(__FILE__)) + '/config.yml'
configFile = YAML::load(File.open(fn))

screenshots_path = File.dirname(File.expand_path(__FILE__)) + '/../../results/screenshots/*'
screenshots_path = screenshots_path.gsub(' ','\ ')
if !Dir[screenshots_path].empty?
    system('rm ' + screenshots_path)
end

hostname = ENV['SERVER'] || configFile['server']
BASE_URL = ("http://qa-ubuntu-10-4-64/portal/auth/portal/groundwork-monitor/")

#Autodiscovery hosts array
$host_array = Array.new

#Sets build properties
NAME = ENV['NAME'] || "#{configFile['name']}"
VERSION = ENV['VERSION'] || "#{configFile['version']}"

def check_browser(browser)
    if browser == "firefox" || browser == "chrome" || browser == "ie"
        return true
    else
        return false
    end
end

def check_bool(bool_value)
    if bool_value == 'true' || bool_value == 'false'
        return true
    else
        return false
    end
end

def check_agent(agent)
    if agent == 'iphone' || agent == 'ipad' || agent == 'android_phone' || agent == 'android_tablet' || agent == 'none'
        return true
    else
        return false
    end
end

def check_grid(grid)
    if grid != "false" && grid != "none"
        return true
    else
        return false
    end
end

require 'watir-webdriver'
require 'page-object'
require 'page-object/page_factory'
require 'date'
require 'webdriver-user-agent'
require 'faker'
require 'securerandom'
require 'quoth'

include Selenium

$: << File.dirname(__FILE__)+'/../../lib'
require 'pages.rb'
require 'ruby_extensions.rb'
require 'nagvis_mapinfo.rb'

World PageObject::PageFactory
PageObject.default_element_wait = 10

agent_value = ENV['AGENT'] || configFile['agent']
browser_value = ENV['BROWSER'] || configFile['browser']

if !check_agent(agent_value)
    abort("Agent not found!")
elsif agent_value != "none"
   DRIVER = UserAgent.driver(:browser => :firefox, :agent => agent_value.to_sym, :orientation => :landscape )
elsif !check_browser(browser_value)
    abort("Browser not found!")
else
    DRIVER = browser_value.to_sym
end

headless_value = ENV['HEADLESS'] || configFile['headless']
if !check_bool(headless_value.to_s)
    abort("Wrong HEADLESS argument!")
end

if headless_value.to_s == "true"
    require 'headless'
    headless = Headless.new
    headless.start
    at_exit do
        headless.destroy
    end
end

client = Selenium::WebDriver::Remote::Http::Default.new
client.timeout = 180

grid_value = ENV['GRID'] || configFile['grid']
if check_grid(grid_value)
    capabilities = WebDriver::Remote::Capabilities.class_eval(browser_value)
    browser = Watir::Browser.new(:remote, :url => grid_value, :desired_capabilities => capabilities, :http_client => client)
else
    browser = Watir::Browser.new DRIVER, :http_client => client
end

#Implicit wait of 1 second
browser.driver.manage.timeouts.implicit_wait = 1

#First login
browser.goto BASE_URL

browser.text_field(:name => 'josso_username').set 'admin' 
browser.text_field(:name => 'josso_password').set 'admin'
browser.button(:value => 'Login').click

Before {
    clear_cookies = ENV['CLEAR_COOKIES'] || configFile['clear_cookies']
    @browser = browser
    if !check_bool(clear_cookies.to_s)
        abort("Wrong CLREAR_COOKIES value")
    elsif clear_cookies.to_s == "true"
        @browser.cookies.clear
    end
}

After do |scenario|
    Dir::mkdir('results/screenshots') if not File.directory?('results/screenshots')
    date_string = DateTime.now.to_s
    date_string.gsub(":","_")
    screenshot = "./screenshots/FAILED_#{scenario.name.gsub(' ','_').gsub(/[^0-9A-Za-z_]/, '')}_#{date_string}.png"
    if scenario.failed?
        @browser.driver.save_screenshot('results/' + screenshot)
        embed screenshot, 'image/png'
    end
end

at_exit do
    browser.close
end
