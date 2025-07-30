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
  end
end

# Base62.encode(1024)
# Base62.decode("xt")
