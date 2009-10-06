module Watir
  #
  # Description:
  #   Class for FileField element.
  #
  class FFFileField < FFInputElement
    include FileField
    INPUT_TYPES = ["file"]

    #
    # Description:
    #   Sets the path of the file in the textbox.
    #
    # Input:
    #   path - Path of the file.
    #
    def set(path)
      assert_exists

      path.gsub!("\\", "\\\\\\")

      jssh_socket.send("#{element_object}.value = \"#{path}\";\n", 0)
      jssh_socket.read_socket
      fireEvent("onChange")
      
      @@current_level = 0
    end

  end # FileField
end # FireWatir
