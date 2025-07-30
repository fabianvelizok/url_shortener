class Base62
  ALPHABET = ("0".."9").to_a + ("a".."z").to_a + ("A".."Z").to_a
  BASE = ALPHABET.length

  def self.encode(number)
    return "0" if number.zero? || number.nil?

    result = ""

    while number > 0 do
      index = number % BASE
      result.prepend(ALPHABET[index])
      number /= BASE
    end

    result
  end

  def self.decode(string)
    result = 0

    string.reverse.each_char.with_index do |char, index|
      power = BASE**index # 62^0, 62^1, 62^2, ...
      index = ALPHABET.index(char)
      result += index * power
    end

    result
  end
end
