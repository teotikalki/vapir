module Watir
  # Base class for html elements.
  # This is not a class that users would normally access.
  class IEElement # Wrapper
    include IEContainer # presumes @container is defined
    include Element
    extend DomWrap
    include Watir::Exception
    attr_accessor :container
    
    # number of spaces that separate the property from the value in the to_s method
    TO_S_SIZE = 14
    
    def initialize(how, what, extra={})
      @how, @what=how, what
      raise ArgumentError, "how (first argument) should be a Symbol, not: #{how.inspect}" unless how.is_a?(Symbol)
      @extra=extra
      @index=extra[:index] && Integer(extra[:index])
      @container=extra[:container]
      @browser=extra[:browser]
      locate! unless extra.key?(:locate) && !extra[:locate]
    end
    
    # Return the ole object, allowing any methods of the DOM that Watir doesn't support to be used.
    #def ole_object # BUG: should use an attribute reader and rename the instance variable
    #  return @o
    #end

    class << self
      #TODO/FIX: repeated on both Element base classes; move to common 
      def factory(element_object, extra={})
        curr_klass=self
        ObjectSpace.each_object(Class) do |klass|
          if klass < curr_klass
            Watir::Specifier.match_candidates([element_object], klass.specifiers) do |match|
              curr_klass=klass
            end
          end
        end
        curr_klass.new(:element_object, element_object, extra)
      end
    end
    
    alias ole_object element_object 
    alias containing_object element_object
    #def ole_object=(o)
    #  @element_object = o
    #end
    
    dom_wrap :currentStyle
    dom_wrap :disabled, :disabled? => :disabled # this applies to all elements for IE, apparently. 
    def enabled?
      !disabled
    end
    
    private
    def base_element_class
      IEElement
    end
    def browser_class
      IE
    end
    private
#    def self.def_wrap(ruby_method_name, ole_method_name=nil)
#      ole_method_name = ruby_method_name unless ole_method_name
#      class_eval "def #{ruby_method_name}
#                          assert_exists
#                          ole_object.invoke('#{ole_method_name}')
#                        end"
#    end
#    def self.def_wrap_guard(method_name)
#      class_eval "def #{method_name}
#                          assert_exists
#                          begin
#                            ole_object.invoke('#{method_name}')
#                          rescue
#                            ''
#                          end
#                        end"
#    end



    public
    
    # return the unique COM number for the element
    dom_wrap :uniqueNumber, :unique_number => :uniqueNumber
    # Return the outer html of the object - see http://msdn.microsoft.com/workshop/author/dhtml/reference/properties/outerhtml.asp?frame=true
    dom_wrap :outerHTML, :outer_html => :outerHTML

    # return the text before the element
    # TODO/FIX: ?
    def before_text # label only
      assert_exists
      ole_object.getAdjacentText("afterEnd").strip
    end
    
    # return the text after the element
    def after_text # label only
      assert_exists
      ole_object.getAdjacentText("beforeBegin").strip
    end
    
    # Returns the text content of the element.
    dom_wrap :text => :innerText
    
#    def ole_inner_elements
#      assert_exists
#      return ole_object.all
#    end
#    private :ole_inner_elements
    
#    def document
#      assert_exists
#      return ole_object
#    end

    # Return the element immediately containing self. 
    def parent(options={})
      @parent=nil if options[:reload]
      @parent||=begin
        parentNode=element_object.parentNode # TODO/FIX: should this use parentElement? 
        if parentNode && parentNode != document_object # don't ascend up to the document
          IEElement.factory(parentNode, extra)
        else
          nil
        end
      end
    end
    
#    include Comparable
#    def <=> other
#      assert_exists
#      other.assert_exists
#      ole_object.sourceindex <=> other.ole_object.sourceindex
#    end
    dom_wrap :sourceindex => :sourceIndex

#    # Return true if self is contained earlier in the html than other. 
#    alias :before? :< 
#    # Return true if self is contained later in the html than other. 
#    alias :after? :> 
      
    def typingspeed
      @container.typingspeed
    end
    def type_keys
      @type_keys || @container.type_keys
    end
    def activeObjectHighLightColor
      @container.activeObjectHighLightColor
    end
    
    # This method is responsible for setting and clearing the colored highlighting on the currently active element.
    # use :set   to set the highlight
    #   :clear  to clear the highlight
    # TODO: Make this two methods: set_highlight & clear_highlight
    # TODO: Remove begin/rescue blocks
    def highlight(set_or_clear)
      if set_or_clear == :set
        begin
          @original_color ||= style.backgroundColor
          style.backgroundColor = @container.activeObjectHighLightColor
        rescue
          @original_color = nil
        end
      else # BUG: assumes is :clear, but could actually be anything
        begin
          style.backgroundColor = @original_color unless @original_color == nil
        rescue
          # we could be here for a number of reasons...
          # e.g. page may have reloaded and the reference is no longer valid
        ensure
          @original_color = nil
        end
      end
    end
    private :highlight
    
    #   This method clicks the active element.
    #   raises: UnknownObjectException  if the object is not found
    #   ObjectDisabledException if the object is currently disabled
    def click
      assert_exists
      assert_enabled if respond_to?(:assert_enabled)
      
      with_highlight do
        ole_object.click
      end
      wait
    end
    
    def click_no_wait
      assert_exists
      assert_enabled if respond_to?(:assert_enabled)
      with_highlight do
        unique_number=element_object.uniqueNumber
        #Thread.new { ole_object.click } # that doesn't work.
         browser.document.parentWindow.setTimeout("
          (function(tagName, uniqueNumber)
          { var candidate_elements=document.getElementsByTagName(tagName);
            for(var i=0;i<candidate_elements.length;++i)
            { if(candidate_elements[i].uniqueNumber==uniqueNumber)
              { candidate_elements[i].click();
              }
            }
          })(#{self.tagName.to_json}, #{element_object.uniqueNumber.to_json})
        ", 0)
      end
    end

    # Executes a user defined "fireEvent" for objects with JavaScript events tied to them such as DHTML menus.
    #   usage: allows a generic way to fire javascript events on page objects such as "onMouseOver", "onClick", etc.
    #   raises: UnknownObjectException  if the object is not found
    #           ObjectDisabledException if the object is currently disabled
    def fire_event(event, options={})
      options={:highlight => !options[:just_fire], :just_fire => false}.merge(options)
      assert_enabled if !options[:just_fire] && respond_to?(:assert_enabled)
      with_highlight(options[:highlight]) do
        ole_object.fireEvent(event.to_s)
        wait
      end
    end
    # Executes a user defined "fireEvent" for objects with JavaScript events tied to them such as DHTML menus.
    #   usage: allows a generic way to fire javascript events on page objects such as "onMouseOver", "onClick", etc.
    #   raises: UnknownObjectException  if the object is not found
    #           ObjectDisabledException if the object is currently disabled
    def fire_event_no_wait(event, options)
      assert_enabled if respond_to?(:assert_enabled)
      options={:highlight => true}.merge(options)
      with_highlight(options[:highlight]) do
        unique_number=element_object.uniqueNumber
        #Thread.new { ole_object.click } # that doesn't work.
        browser.document.parentWindow.setTimeout("
          (function(tagName, uniqueNumber, event)
          { var candidate_elements=document.getElementsByTagName(tagName);
            for(var i=0;i<candidate_elements.length;++i)
            { if(candidate_elements[i].uniqueNumber==uniqueNumber)
               { candidate_elements[i].fireEvent(event);
              }
            }
          })(#{self.tagName.to_json}, #{element_object.uniqueNumber.to_json}, #{event.to_s.to_json})
        ", 0)
      end
    end
    
    def wait(options={})
      @container.wait(options)
    end

    # If any parent element isn't visible then we cannot write to the
    # element. The only realiable way to determine this is to iterate
    # up the DOM element tree checking every element to make sure it's
    # visible.
    def visible?
      # Now iterate up the DOM element tree and return false if any
      # parent element isn't visible or is disabled.
      assert_exists
      object = @element_object
      while object
        begin
          if object.currentstyle.invoke('visibility') =~ /^hidden$/i
            return false
          end
          if object.currentstyle.invoke('display') =~ /^none$/i
            return false
          end
          if object.invoke('isDisabled')
            return false
          end
        rescue WIN32OLERuntimeError
        end
        object = object.parentElement
      end
      true
    end
    
    # Get attribute value for any attribute of the element.
    # Returns null if attribute doesn't exist.
    def attribute_value(attribute_name)
      assert_exists
      return ole_object.getAttribute(attribute_name)
    end
    
    private
    def ole_to_element_collection(element_class, ole_collection)
      elements=[]
      (0...ole_collection.length).each do |i|
        elements << element_class.new(:element_object, ole_collection.item(i), extra)
      end
      ElementCollection.new(elements)
    end
  end
  
  class ElementMapper # Still to be used
    include IEContainer
    
    def initialize wrapper_class, container, how, what
      @wrapper_class = wrapper_class
      set_container
      @how = how
      @what = what
    end
    
    def method_missing method, *args
      locate
      @wrapper_class.new(@element_object).send(method, *args)
    end
  end
end  
