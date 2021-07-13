RSpec.describe Helium::Dependency do
  let(:klass) do
    Class.new do
      include Helium::Dependency

      dependency(:object) { "object" }
      dependency(:id, public: true) { "object-#{object.object_id}" }

      def initialize(name)
        @name = name
      end

      attr_reader :name
    end
  end

  context "with no dependency is explicitly passed" do
    let(:name) { FFaker::Lorem.words(2).join('-') }
    subject { klass.new(name) }

    it "uses default injection blocks" do
      expect(subject.send(:object)).to eq "object"
    end

    it "allows referencing other dependencies" do
      expect(subject.id).to eq "object-#{subject.send(:object).object_id}"
    end

    it "does not override initialize method" do
      expect(subject.name).to eq name
    end
  end

  context "with some dependency explicitly passed" do
    let(:object) { Object.new }
    let(:name) { FFaker::Lorem.words(2).join('-') }

    subject { klass.new(name, object: object) }

    it "uses explicit injection" do
      expect(subject.send(:object)).to be object
    end

    it "allows referencing other dependencies" do
      expect(subject.id).to eq "object-#{object.object_id}"
    end

    it "does not override initialize method" do
      expect(subject.name).to eq name
    end
  end

  describe "in a subclass" do
    let(:subclass) do
      Class.new(klass) do
        dependency(:subclass_dependency) { "hello" }
      end
    end

    subject { subclass.new("some name") }

    it "inherits parent class dependencies" do
      expect(subject.id).to eq "object-#{subject.send(:object).object_id}"
    end

    it "has own dependencies" do
      expect(subject.send :subclass_dependency).to eq "hello"
    end

    it "does not add dependency to the parent class" do
      subject # ensures the subclass is evaluated
      parent_class_object = klass.new("name")

      expect { klass.new('').send :subclass_dependency }.to raise_error NameError
    end
  end
end
