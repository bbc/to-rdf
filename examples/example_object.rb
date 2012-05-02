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
foo.date = DateTime.new
puts foo.to_rdf
