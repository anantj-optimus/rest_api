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



