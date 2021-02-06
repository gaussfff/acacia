# acacia
Parser generator for translators in Common Lisp

## Rules
### :rule
```lisp
  (:rule <name>)
```

### :and
```lisp
  (:and
      <rule-1>
      ...
      <rule-n>)
```

### :or
```lisp
  (:or
    <rule-1>
    ...
    <rule-n>)
```

### :empty
```lisp
  (:empty)
```

### :no-term-sym <sym> [opt] <value>
```lisp
  (:no-term-sym <sym> [opt] <value>)
```
opt is !:, value as name of non print symbol
if value is nil, then checked only sym
  

