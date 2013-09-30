# encoding: utf-8
require 'json/schema_generator'

def compare_without_whitespace actual, expected
  actual_cleaned = actual.gsub(/^\s+/, '').gsub(/\s+$/, '')
  expected_cleaned = expected.gsub(/^\s+/, '').gsub(/\s+$/, '')
  expect(actual_cleaned).to eq expected_cleaned
end

module JSON
  describe SchemaGenerator do
    describe '.generate' do
      Dir['spec/fixtures/examples/*.json'].each do |example_file|
        example = File.basename example_file
        expected = File.expand_path(example, 'spec/fixtures/schemas')
        it "generates the expected schema for #{example}" do
          schema = described_class.generate example_file
          compare_without_whitespace schema, File.read(expected)
        end
      end
    end
  end
end
