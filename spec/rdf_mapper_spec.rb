require 'spec_helper'
require 'uri'

describe RdfMapper do

  include RdfMapper

  it "maps Ruby values to RDF/Turtle values" do
    node_to_s('string').should eq('"""string"""')
    node_to_s(1).should eq("1")
    node_to_s(DateTime.new(2012, 4, 2)).should eq('"2012-04-02T00:00:00+00:00"^^xsd:dateTime')
    node_to_s(URI('http://example.com')).should eq('<http://example.com>')
    node_to_s(nil).should eq(nil)
  end

  it "deals correctly with empty objects" do
    class Foo1
      include RdfMapper
    end
    Foo1.new.to_rdf.should eq(nil)
  end

  it "maps Ruby objects to RDF/Turtle" do
    class Foo2
      include RdfMapper
      def name
        "blah"
      end
      def uri
        URI("http://example.com")
      end
      def type_uri
        URI("http://example.com/Foo")
      end
      def rdf_mapping
        { "foo:name" => name }
      end
    end
    Foo2.new.to_rdf.should eq("<http://example.com>\n\ta <http://example.com/Foo> ;\n\tfoo:name \"\"\"blah\"\"\" ;\n\t.\n")
  end

end
