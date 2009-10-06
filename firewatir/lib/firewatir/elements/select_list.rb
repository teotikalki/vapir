module Watir
  #
  # Description:
  #   Class for SelectList element.
  #
  class FFSelectList < FFInputElement
    include SelectList
    INPUT_TYPES = ["select-one", "select-multiple"]

    #
    # Description:
    #   Clears the selected items in the select box.
    #
    def clear
      assert_exists
      #highlight( :set)
      wait = false
      each do |selectBoxItem|
        if selectBoxItem.selected
          selectBoxItem.assign('selected', false)
          wait = true
        end
      end
      self.wait if wait
      #highlight( :clear)
    end
    alias clearSelection clear

    def each
      assert_exists
      js_options.each do |option|
        yield FFOption.new(self, :jssh_name, option.ref)
      end
    end

    #
    # Description:
    #   Get option element at specified index in select list.
    #
    # Input:
    #   key - option index
    #
    # Output:
    #   Option element at specified index
    #
    def [] (key)
      assert_exists
      arr_options = js_options
      return FFOption.new(self, :jssh_name, arr_options[key - 1].ref)
    end

    #
    # Description:
    #   Selects an item by text. If you need to select multiple items you need to call this function for each item.
    #
    # Input:
    #   - item - Text of item to be selected.
    #
    def select( item )
      select_items_in_select_list(:text, item)
    end
    alias :set :select

    #
    # Description:
    #   Selects an item by value. If you need to select multiple items you need to call this function for each item.
    #
    # Input:
    # - item - Value of the item to be selected.
    #
    def select_value( item )
      select_items_in_select_list(:value, item)
    end

    #
    # Description:
    #   Gets all the items in the select list as an array.
    #   An empty array is returned if the select box has no contents.
    #
    # Output:
    #   Array containing the items of the select list.
    #
    def options
      assert_exists
      #element.log "There are #{@o.length} items"
      returnArray = []
      each { |thisItem| returnArray << thisItem.text }
      return returnArray
    end

    alias getAllContents options

    #
    # Description:
    #   Gets all the selected items in the select list as an array.
    #   An empty array is returned if the select box has no selected item.
    #
    # Output:
    #   Array containing the selected items of the select list.
    #
    def selected_options
      assert_exists
      returnArray = []
      #element.log "There are #{@o.length} items"
      each do |thisItem|
        #puts "#{thisItem.selected}"
        if thisItem.selected
          #element.log "Item ( #{thisItem.text} ) is selected"
          returnArray << thisItem.text
        end
      end
      return returnArray
    end

    alias getSelectedItems selected_options

    #
    # Description:
    #   Get the option using attribute and its value.
    #
    # Input:
    #   - attribute - Attribute used to find the option.
    #   - value - value of that attribute.
    #
    def option (attribute, value)
      assert_exists
      FFOption.new(self, attribute, value)
    end
    
    private
    
    # Description:
    #   Selects items from the select box.
    #
    # Input:
    #   - name  - :value or :text - how we find an item in the select box
    #   - item  - value of either item text or item value.
    #
    def select_items_in_select_list(attribute, value)
      assert_exists
      
      attribute = attribute.to_s
      found     = false
      
      value = value.to_s unless [Regexp, String].any? { |e| value.kind_of? e }

      highlight( :set )
      each do |option|
        next unless value.matches(option.invoke(attribute))
        found = true  
        next if option.selected
        
        option.assign('selected', true)
        fireEvent("onChange")
        wait
      end
      highlight( :clear )

      unless found
        raise Exception::NoValueFoundException, "No option with #{attribute} of #{value.inspect} in this select element"
      end
      
      value
    end

    #
    # Description:
    #   Gets all the options of the select list element.
    #
    # Output:
    #   Array of option elements.
    #
    def js_options
      dom_object.options.to_array
    end
  
  end # Selects
end # FireWatir
