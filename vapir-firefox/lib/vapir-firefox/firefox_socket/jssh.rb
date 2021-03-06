require 'vapir-firefox/firefox_socket/base'

# A JsshSocket represents a connection to Firefox over a socket opened to the JSSH extension. 
class JsshSocket < FirefoxSocket
  @configuration_parent = FirefoxSocket.config
  config.update_hash({
    :port => 9997,
  })

  # returns an array of command line flags that should be used to invoke firefox for jssh 
  def self.command_line_flags(options={})
    options = config.defined_hash.merge(options)
    ['-jssh', '-jssh-port', options['port']]
  end

  def eat_welcome_message
    @prompt="\n> "
    welcome="Welcome to the Mozilla JavaScript Shell!\n"
    read=read_value
    if !read
      @expecting_extra_maybe=true
      raise FirefoxSocketUnableToStart, "Something went wrong initializing - no response" 
    elsif read != welcome
      @expecting_extra_maybe=true
      raise FirefoxSocketUnableToStart, "Something went wrong initializing - message #{read.inspect} != #{welcome.inspect}" 
    end
  end
  def initialize_environment
    # set up objects that are needed: nativeJSON_encode_length, VapirTemp, and Vapir
    ret=send_and_read(%Q((function()
    { nativeJSON_encode_length=function(object)
      { var encoded=JSON.stringify(object);
        return encoded.length.toString()+"\\n"+encoded;
      }
      VapirTemp = {};
      Vapir = {};
      return 'done!';
    })()))
    if ret != "done!"
      @expecting_extra_maybe=true
      raise FirefoxSocketError, "Something went wrong initializing environment - message #{ret.inspect}"
    end
  end

  # returns a JavascriptObject representing the return value of JSSH's builtin getWindows() function. 
  def getWindows
    root.getWindows
  end
end
