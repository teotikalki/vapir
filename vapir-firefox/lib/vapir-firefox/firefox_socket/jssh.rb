require 'vapir-firefox/firefox_socket/base'

# A JsshSocket represents a connection to Firefox over a socket opened to the JSSH extension. 
class JsshSocket < FirefoxSocket
  @configuration_parent = FirefoxSocket.config
  config.update_hash({
    :port => 9997,
  })

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
  def initialize_length_json_writer
    ret=send_and_read(%Q((function()
    { nativeJSON=Components.classes['@mozilla.org/dom/json;1'].createInstance(Components.interfaces.nsIJSON);
      nativeJSON_encode_length=function(object)
      { var encoded=nativeJSON.encode(object);
        return encoded.length.toString()+"\\n"+encoded;
      }
      return 'done!';
    })()))
    if ret != "done!"
      @expecting_extra_maybe=true
      raise FirefoxSocketError, "Something went wrong initializing native JSON - message #{ret.inspect}"
    end
  end
end

