module JsonMatcherHelper
  class IterationFailed < StandardError
    attr_reader :traversed_path
    attr_reader :next_key
    def initialize(traversed_path, next_key)
      @traversed_path = traversed_path
      @next_key = next_key
    end
  end
  class ExpectedArray < IterationFailed
    def initialize(traversed_path, key_to_traverse)
      super(traversed_path, key_to_traverse)
    end
  end
  def self.traverse(root, next_key_list, traversed_path = [])
    return root if next_key_list.blank?

    key_to_traverse, *rest = next_key_list

    if key_to_traverse.is_a?(Integer)
      if !root.is_a?(Array)
        raise ExpectedArray.new(traversed_path, key_to_traverse)
      end

      return traverse(root[key_to_traverse], rest, traversed_path + [key_to_traverse])
    end

    if root.nil? || !root.has_key?(key_to_traverse)
      raise IterationFailed.new(traversed_path, key_to_traverse)
    end

    traverse(root[key_to_traverse], rest, traversed_path + [key_to_traverse])
  end
end

RSpec::Matchers.define :have_json_path do |*keys|
  key_path = keys.join('.')

  match do |obj|
    raw_hash =
      if obj.respond_to?(:body)
        JSON.parse(obj.body)
      end

    traversed = JsonMatcherHelper.traverse(raw_hash, keys)
    if expected_value.present?
      @reason = :values_dont_match
      @traversed_value = traversed
      values_match?(traversed, expected_value)
    elsif expected_array_size.present?
      @reason = :array_size_doesnt_match
      @traversed_array_size = traversed.size
      values_match?(traversed.size, expected_array_size)
    else
      true
    end
  rescue JsonMatcherHelper::IterationFailed => e
    @traversed_path = e.traversed_path
    @next_key = e.next_key
    @reason = :traversal_failure
    false
  end

  chain :with_value, :expected_value
  chain :with_array_size, :expected_array_size

  failure_message do
    base_message =
      if expected_value.present?
        "object is expected to have key \"#{key_path}\" with value \"#{expected_value}\""
      elsif expected_array_size.present?
        "object is expected to have key \"#{key_path}\" with array size of #{expected_array_size}"
      else
        "object is expected to have key \"#{key_path}\""
      end

    case @reason
    when :traversal_failure
      [
        base_message,
        "but the next key \"#{@next_key}\" is not found when traversing #{@traversed_path.join('.').presence || "root"}"
      ].join(', ')
    when :values_dont_match
      [
        base_message,
        "but value is \"#{@traversed_value}\""
      ].join(', ')
    when :array_size_doesnt_match
      [
        base_message,
        "but array size is #{@traversed_array_size}"
      ].join(', ')
    end
  end
end
