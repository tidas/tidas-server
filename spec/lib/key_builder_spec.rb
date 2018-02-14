require 'spec_helper'

good_hex_bytes      = "04C6314AE7C1462EE110018A720640D5C0253FBCEE49E3BC55CE9955552C3925E33096FF624C8594FBEACF72C580AD400CF415C3C7FDD6BDB04B776D1594A929CD"
valid_key_builder   = Tidas::Utilities::KeyBuilder.init_with_hex_key_bytes(good_hex_bytes)
valid_pub_string = "-----BEGIN PUBLIC KEY-----\nMFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAExjFK58FGLuEQAYpyBkDVwCU/\nvO5J47xVzplVVSw5JeMwlv9iTIWU++rPcsWArUAM9BXDx/3WvbBLd20VlKkp\nzQ==\n-----END PUBLIC KEY-----\n"

describe Tidas::Utilities::KeyBuilder do
  describe 'init_with_hex_key_bytes' do
    context "when given valid bytes for a public key" do
      it "should return a valid KeyBuilder object" do
        hex_bytes = good_hex_bytes
        k = Tidas::Utilities::KeyBuilder.init_with_hex_key_bytes(hex_bytes)
        expect(k.class) == Tidas::Utilities::KeyBuilder
      end
    end

    context "when given bad bytes for a public key" do
      it "should raise an exception" do
        hex_bytes = "04C6314AE7C1462EE110018A720640D5C0253FBCEE49E3BC55CE9955552C3925EFBEACF72C580AD400CF415C3C7FDD6BDB04B776D1594A929CD"
        k = Tidas::Utilities::KeyBuilder.init_with_hex_key_bytes(hex_bytes)
        expect(k.class) == Tidas::Utilities::KeyBuilder::KeyError
      end
    end
  end

  describe 'pub_key' do

    context "when not given a file to write to" do
      it "should return a string containing the public key in pub format" do
        k = valid_key_builder
        # binding.pry
        expect(k.pub) == valid_pub_string
      end
    end

    context "when given a file to write to" do
      it "should write a string containing the public key in pub format to that file" do
        hex_bytes = "04C6314AE7C1462EE110018A720640D5C0253FBCEE49E3BC55CE9955552C3925EFBEACF72C580AD400CF415C3C7FDD6BDB04B776D1594A929CD"
        k = valid_key_builder
        k.export_pub('/tmp/out_test.pub')
        expect(File.exist?('/tmp/out_test.pub')) == true
      end

      after do
        File.delete('/tmp/out_test.pub')
      end
    end
  end

end
