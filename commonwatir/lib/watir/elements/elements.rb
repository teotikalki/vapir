require 'watir/elements/element'

module Watir
  module Container
  end
  module Document
  end
  
  module Frame
    Specifiers=[ {:tagName => 'frame'},
                 {:tagName => 'iframe'},
               ]
    include ContainerMethodsFromName
    include ElementModule
    DefaultHow=:name
    
    dom_wrap :name, :src
  end
  module InputElement
    Specifiers= [ {:tagName => 'input'},
                  {:tagName => 'textarea'},
                  {:tagName => 'button'},
                  {:tagName => 'select'},
                ]
    ContainerSingleMethod=['input', 'input_element']
    ContainerMultipleMethod=['inputs', 'input_elements']
    include ElementModule
    
    dom_wrap :name, :value, :type, :default_value => :defaultValue
  end
  module TextField
    Specifiers= [ {:tagName => 'textarea'},
                  {:tagName => 'input', :types => ['text', 'textarea','password','hidden']},
                ]
    include ContainerMethodsFromName
    include ElementModule
    
    dom_wrap :size, :readonly => :readOnly, :readonly? => :readOnly
  end
  module Hidden
    Specifiers=[{:tagName => 'input', :type => 'hidden'}]
    include ContainerMethodsFromName
    DefaultHow=:name
    include ElementModule
  end
  module Button
    Specifiers=[ {:tagName => 'input', :types => ['button', 'submit', 'image', 'reset']}, 
                 {:tagName => 'button'}
               ]
    include ContainerMethodsFromName
    DefaultHow=:value
    include ElementModule
    dom_wrap :src, :height, :width # these are used on <input type=image>
  end
  module FileField
    Specifiers=[{:tagName => 'input', :type => 'file'}]
    include ContainerMethodsFromName
    DefaultHow=:name
    include ElementModule
  end
  module Option
    TAG='option'
    include ContainerMethodsFromName
    include ElementModule
    dom_wrap :text, :value, :selected, :selected=
  end
  module SelectList
    TAG='select'
    include ContainerMethodsFromName
    include ElementModule
  end
  module Radio
    Specifiers=[{:tagName => 'input', :type => 'radio'}]
    include ContainerMethodsFromName
    ContainerMethodExtraArgs=[:value]
    include ElementModule
    
    dom_wrap :checked
  end
  module CheckBox
    Specifiers=[{:tagName => 'input', :type => 'checkbox'}]
    ContainerSingleMethod=['checkbox', 'check_box']
    ContainerMultipleMethod=['checkboxes', 'check_boxes']
    ContainerMethodExtraArgs=[:value]
    include ElementModule

    dom_wrap :checked
  end
  module Form
    TAG='form'
    include ContainerMethodsFromName
    DefaultHow=:name
    include ElementModule
    
    dom_wrap :action
  end
  module Image
    TAG = 'IMG'
    include ContainerMethodsFromName
    DefaultHow=:name
    include ElementModule
    
    dom_wrap :alt, :src, :name, :height, :width, :border
  end
  module Table
    TAG = 'TABLE'
    include ContainerMethodsFromName
    include ElementModule
  end
  module TBody
    TAG = 'TBODY'
    ContainerSingleMethod=['tbody']
    ContainerMultipleMethod=['tbodies']
    include ElementModule
  end
  module TableRow
    TAG='tr'
    include ContainerMethodsFromName
    include ElementModule
  end
  module TableCell
    TAG='td'
    include ContainerMethodsFromName
    include ElementModule
    dom_wrap :colSpan, :rowSpan, :colspan => :colSpan, :rowspan => :rowSpan
  end
  module Link
    TAG = 'A'
    ContainerSingleMethod=['a', 'link']
    ContainerMultipleMethod=['as', 'links']
    include ElementModule
    
    dom_wrap :href, :name
  end
  module Pre
    TAG = 'PRE'
    include ContainerMethodsFromName
    include ElementModule
  end
  module P
    TAG = 'P'
    include ContainerMethodsFromName
    include ElementModule
  end
  module Div
    TAG = 'DIV'
    include ContainerMethodsFromName
    include ElementModule
  end
  module Span
    TAG = 'SPAN'
    include ContainerMethodsFromName
    include ElementModule
  end
  module Strong
    TAG = 'STRONG'
    include ContainerMethodsFromName
    include ElementModule
  end
  module Label
    TAG = 'LABEL'
    include ContainerMethodsFromName
    include ElementModule
    
    dom_wrap :htmlFor, :for => :htmlFor
  end
  module Ul
    TAG = 'UL'
    include ContainerMethodsFromName
    include ElementModule
  end
  module Li
    TAG = 'LI'
    include ContainerMethodsFromName
    include ElementModule
  end
  module Dl
    TAG = 'DL'
    include ContainerMethodsFromName
    include ElementModule
  end
  module Dt
    TAG = 'DT'
    include ContainerMethodsFromName
    include ElementModule
  end
  module Dd
    TAG = 'DD'
    include ContainerMethodsFromName
    include ElementModule
  end
  module H1
    TAG = 'H1'
    include ContainerMethodsFromName
    include ElementModule
  end
  module H2
    TAG = 'H2'
    include ContainerMethodsFromName
    include ElementModule
  end
  module H3
    TAG = 'H3'
    include ContainerMethodsFromName
    include ElementModule
  end
  module H4
    TAG = 'H4'
    include ContainerMethodsFromName
    include ElementModule
  end
  module H5
    TAG = 'H5'
    include ContainerMethodsFromName
    include ElementModule
  end
  module H6
    TAG = 'H6'
    include ContainerMethodsFromName
    include ElementModule
  end
  module Map
    TAG = 'MAP'
    include ContainerMethodsFromName
    include ElementModule
  end
  module Area
    TAG = 'AREA'
    include ContainerMethodsFromName
    include ElementModule
  end
  module Em
    TAG = 'EM'
    include ContainerMethodsFromName
    include ElementModule
  end
end
