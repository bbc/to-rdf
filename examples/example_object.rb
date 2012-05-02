require 'rubygems'
require 'rdf_mapper'
require 'uri'

class Foo

  attr_accessor :name, :date

  include RdfMapper

  # The URI of the object
  def uri
    URI('http://example.com/foo')
  end

  # The URI of the type of the object
  def type_uri
    URI('http://purl.org/ontology/Foo')
  end

  def namespaces
    super.merge 'foo' => 'http://example.com/ontology/'
  end

  # The mapping to RDF properties
  def rdf_mapping
    {
      'foo:name' => name,
      'foo:date' => date,
    }
  end
  
end

foo = Foo.new
foo.name = "Name"
foo.date = DateTime.new(2012,4,4)
puts foo.to_rdf
