class AttrAccessorObject
  def self.my_attr_accessor(*names)
    names.each do |name|
      class_eval("def #{name}; @#{name}; end")
      class_eval("def #{name}=(value); @#{name} = value; end")
    end
  end
end
