RSpec.describe HashEx do
  it "has a version number" do
    expect(HashEx::VERSION).not_to be nil
  end
end

RSpec.describe HashEx::Base do
  h = HashEx::Base.new

  it "must override #convert_key" do
    expect { h[:a] }.to raise_error("Method #convert_key must be rewritten")
  end
end

RSpec.describe HashEx::JsObject do
  h = HashEx::JsObject.new({a: {b: 1}})

  it "h.a is an instance of HashEx::JsObject" do
    expect(h.a.class).to be HashEx::JsObject
  end

  it "h.a.b is accessable" do
    expect(h.a.b).to be 1
  end

  it "h.c is assignable" do
    expect { h.c = 'foo' }.not_to raise_error
  end

  it "h[:c] is equal to 'foo'" do
    expect(h[:c]).to eq('foo')
  end

  it "h[:c] is equal to h['c']" do
    expect(h[:c]).to eq(h['c'])
  end

  it "h['D'] is assignable" do
    expect { h['D'] = { 'E' => 'bar' } }.not_to raise_error
  end

  it "h[:D] is an instance of HashEx::JsObject" do
    expect( h[:D].class ).to be HashEx::JsObject
  end

  it "h.D[:E] is equal to 'bar'" do
    expect( h.D[:E] ).to eq('bar')
  end

  it "h.D.F is assignable" do
    expect { h.D.F = 'baz' }.not_to raise_error
  end

  it "h.D['F'] is equal to 'baz'" do
    expect( h.D['F'] ).to eq('baz')
  end

  it "h.D['G'] is assignable" do
    expect { h.D['G'] = 'abc' }.not_to raise_error
  end

  it "h.D.G is equal to 'abc'" do
    expect( h.D.G ).to eq('abc')
  end

  t = h.to_h
  it "h.to_h is an instance of Hash" do
    expect( t.class ).to be Hash
  end

  it "h.to_h['a'] is an instance of Hash" do
    expect( t['a'].class ).to be Hash
  end

  it "h.to_h[:a] is nil" do
    expect( t[:a] ).to be nil
  end

  h1 = HashEx::JsObject.new(1)
  it "h1.a is 1" do
    expect( h1.a ).to be 1
  end

  h1.b = { 'c' => 123 }
  it "h1.b.c is 123" do
    expect( h1.b.c ).to be 123
  end
end
