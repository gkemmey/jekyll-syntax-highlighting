describe "loads jekyll-syntax-highlighting grammar", ->
  grammar = null

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage("jekyll-syntax-highlighting")

    runs ->
      grammar = atom.grammars.grammarForScopeName("text.jekyll")

  it "parses the grammar", ->
    expect(grammar).toBeTruthy()
    expect(grammar.scopeName).toBe "text.jekyll"

  it "tokenizes a js highlight block", ->
    {tokens, ruleStack} = grammar.tokenizeLine("{% highlight js %}")

    expect(tokens[0]).toEqual value: "{% highlight js %}", scopes: ["text.jekyll", "markup.code.js.gfm", "support.gfm"]
    expect(ruleStack[1].contentScopeName).toBe "source.embedded.js"

  it "tokenizes a rb highlight block", ->
    {tokens, ruleStack} = grammar.tokenizeLine("{% highlight ruby %}")

    expect(tokens[0]).toEqual value: "{% highlight ruby %}", scopes: ["text.jekyll", "markup.code.ruby.gfm", "support.gfm"]
    expect(ruleStack[1].contentScopeName).toBe "source.embedded.ruby"

  it "tokenizes the endhighlight", ->
    {tokens, ruleStack} = grammar.tokenizeLine("{% highlight js %}")
    {tokens, ruleStack} = grammar.tokenizeLine("console.log('nothing to see here');", ruleStack)
    {tokens} = grammar.tokenizeLine("{% endhighlight %}", ruleStack)

    expect(tokens[0]).toEqual value: "{% endhighlight %}", scopes: ["text.jekyll", "markup.code.js.gfm", "support.gfm"]
