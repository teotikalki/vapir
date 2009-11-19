# feature tests for Check Boxes
# revision: $Revision$

$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..') unless $SETUP_LOADED
require 'unittests/setup'

class TC_CheckBox_XPath < Test::Unit::TestCase
  include Watir::Exception
  
  def setup
    goto_page "checkboxes1.html"
  end
  
  def test_checkbox_properties
    assert_raises(UnknownObjectException) { browser.checkbox(:xpath , "//input[@name='noName']/").id }
    assert_raises(UnknownObjectException) { browser.checkbox(:xpath , "//input[@name='noName']/").name }
    assert_raises(UnknownObjectException) { browser.checkbox(:xpath , "//input[@name='noName']/").disabled }
    assert_raises(UnknownObjectException) { browser.checkbox(:xpath , "//input[@name='noName']/").type }
    assert_raises(UnknownObjectException) { browser.checkbox(:xpath , "//input[@name='noName']/").value }
    
    assert_equal("1" , browser.checkbox!(:xpath , "//input[@name='box4']/").value )
    assert_equal("3" , browser.checkbox!(:xpath , "//input[@name='box4' and @value='3']/").value )
    assert_equal("checkbox" , browser.checkbox!(:xpath , "//input[@name='box4' and @value='3']/").type )
    assert_equal(false , browser.checkbox!(:xpath , "//input[@name='box4' and @value='3']/").disabled )
    assert_equal("" , browser.checkbox!(:xpath , "//input[@name='box4' and @value='3']/").id )
    
    assert_equal("box4-value5" , browser.checkbox!(:xpath , "//input[@name='box4' and @value='5']/").title)
    assert_equal("" , browser.checkbox!(:xpath , "//input[@name='box4' and @value='4']/").title)
  end
  
  def test_CheckBox_Exists
    assert(browser.checkbox(:xpath , "//input[@name='box4' and @value='1']/").exists?)
    assert(!browser.checkbox(:xpath , "//input[@name='box4' and @value='22']/").exists?)
  end
  
  def test_checkbox_Enabled
    assert_raises(UnknownObjectException) { browser.checkbox(:xpath , "//input[@name='noName']/").enabled? }
    assert_raises(UnknownObjectException) { browser.checkbox(:xpath , "//input[@id='noName']/").enabled? }
    assert_raises(UnknownObjectException) { browser.checkbox(:xpath , "//input[@name='box4' and @value='6']/").enabled? }
    
    assert(browser.checkbox!(:xpath , "//input[@name='box1']/").enabled?)   
    assert_false(browser.checkbox!(:xpath , "//input[@name='box2']/").enabled?)   
    
    assert(browser.checkbox!(:xpath , "//input[@name='box4' and @value='4']/").enabled?)   
    assert_false(browser.checkbox!(:xpath , "//input[@name='box4' and @value='5']/").enabled?)   
  end
  
  def test_checkbox_isSet
    assert_raises(UnknownObjectException ) { browser.checkbox(:xpath , "//input[@name='noName']/").checked? }
    
    assert_false(browser.checkbox!(:xpath , "//input[@name='box1']/").checked?)   
    assert_false(browser.checkbox!(:xpath , "//input[@name='box2']/").checked?)   
    assert(browser.checkbox!(:xpath , "//input[@name='box3']/").checked?)   
    
    assert_false(browser.checkbox!(:xpath , "//input[@name='box4' and @value='2']/").checked?)   
    assert(browser.checkbox!(:xpath , "//input[@name='box4' and @value='1']/").checked?)   
  end
  
  def test_checkbox_clear
    assert_raises(UnknownObjectException) { browser.checkbox(:xpath , "//input[@name='noName']/").clear }
    browser.checkbox!(:xpath , "//input[@name='box1']/").clear
    assert_false(browser.checkbox!(:xpath , "//input[@name='box1']/").checked?)   
    
    assert_raises(ObjectDisabledException) { browser.checkbox!(:xpath , "//input[@name='box2']/").clear } 
    assert_false(browser.checkbox!(:xpath , "//input[@name='box2']/").checked?)   
    
    browser.checkbox!(:xpath , "//input[@name='box3']/").clear
    assert_false(browser.checkbox!(:xpath , "//input[@name='box3']/").checked?)   
    
    browser.checkbox!(:xpath , "//input[@name='box4' and @value='1']/").clear
    assert_false(browser.checkbox!(:xpath , "//input[@name='box4' and @value='1']/").checked?)   
  end
  
  def test_checkbox_checked?
    assert_raises(UnknownObjectException) { browser.checkbox(:xpath , "//input[@name='noName']/").checked? }
    assert_equal( false , browser.checkbox!(:xpath , "//input[@name='box1']/").checked? )   
    assert_equal( true , browser.checkbox!(:xpath , "//input[@name='box3']/").checked?)   
    
    # checkboxes that have the same name but different values
    assert_equal( false , browser.checkbox!(:xpath , "//input[@name='box4' and @value='2']/").checked? )   
    assert_equal( true , browser.checkbox!(:xpath , "//input[@name='box4' and @value='1']/").checked?)   
  end
  
  def test_checkbox_set
    assert_raises(UnknownObjectException) { browser.checkbox(:xpath , "//input[@name='noName']/").set }
    browser.checkbox!(:xpath , "//input[@name='box1']/").set
    assert(browser.checkbox!(:xpath , "//input[@name='box1']/").checked?)   
    
    assert_raises(ObjectDisabledException) { browser.checkbox!(:xpath , "//input[@name='box2']/").set }  
    
    browser.checkbox!(:xpath , "//input[@name='box3']/").set
    assert(browser.checkbox!(:xpath , "//input[@name='box3']/").checked?)   
    
    # checkboxes that have the same name but different values
    browser.checkbox!(:xpath , "//input[@name='box4' and @value='3']/").set
    assert(browser.checkbox!(:xpath , "//input[@name='box4' and @value='3']/").checked?)   
    
    # test set using the optinal true/false
    # assumes the checkbox is already checked
    browser.checkbox!(:xpath , "//input[@name='box1']/").set( false )
    assert_false(browser.checkbox!(:xpath , "//input[@name='box1']/").checked?)   
    
    browser.checkbox!(:xpath , "//input[@name='box1']/").set( true )
    assert(browser.checkbox!(:xpath , "//input[@name='box1']/").checked?)   
    
  end
end
