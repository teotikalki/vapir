# defect report from users of Watir Recorder
# revision: $Revision: 746 $

$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..') if $0 == __FILE__
require 'unittests/setup'

class TC_GoogleForm < Test::Unit::TestCase
  
  def setup
    use_page "google_india.html"
  end
  
  def test_it
    $ie.form( :name, "f").text_field( :name, "q").set("ruby")
  end
end