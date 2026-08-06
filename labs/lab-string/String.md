# Especificación de la Biblioteca String

Este archivo es una **referencia**: describe matemáticamente qué debe hacer cada función. Usalo para entender la especificación antes de leer o modificar el código.

## Notación

| Símbolo | Significado |
|---|---|
| `s`, `t` | cadena (tipo String) |
| `c` | carácter (tipo Char) |
| `ε` | cadena vacía `""` |
| `\|s\|` | longitud de la cadena `s` |
| `s[i]` | i-ésimo carácter de `s` (base 0) |
| `s[1..]` | subcadena de `s` desde la posición 1 hasta el final |
| `𝔹` | Boolean = {0, 1} |
| `ℕ₀` | naturales incluyendo el 0 |

---

## IsEmpty

**Signatura:** `IsEmpty : String → 𝔹`

**Especificación:**
```
IsEmpty(s) = 1   si s = ε
IsEmpty(s) = 0   si s ≠ ε
```

---

## GetLength

**Signatura:** `GetLength : String → ℕ₀`

**Especificación:**
```
GetLength(ε)   = 0
GetLength(s)   = 1 + GetLength(s[1..])   si s ≠ ε
```

---

## AreEqual

**Signatura:** `AreEqual : String × String → 𝔹`

**Especificación:**
```
AreEqual(ε, ε)   = 1
AreEqual(ε, t)   = 0                                          si t ≠ ε
AreEqual(s, ε)   = 0                                          si s ≠ ε
AreEqual(s, t)   = (s[0] = t[0]) ∧ AreEqual(s[1..], t[1..])  si s ≠ ε ∧ t ≠ ε
```

Dos cadenas son iguales si y solo si tienen la misma longitud y los mismos caracteres en el mismo orden.

---

## AreDecimalDigits

**Signatura:** `AreDecimalDigits : String → 𝔹`

**Especificación:**
```
AreDecimalDigits(ε)   = 0
AreDecimalDigits(s)   = (s[0] ∈ {'0'..'9'}) ∧ AreDecimalDigits(s[1..])   si |s| > 1
AreDecimalDigits(s)   = (s[0] ∈ {'0'..'9'})                               si |s| = 1
```

La cadena vacía **no** es un conjunto válido de dígitos: se requiere al menos un carácter.

---

## Contains

**Signatura:** `Contains : String × Char → 𝔹`

**Especificación:**
```
Contains(ε, c)   = 0
Contains(s, c)   = 1                    si s[0] = c
Contains(s, c)   = Contains(s[1..], c)  si s[0] ≠ c
```

Devuelve 1 si el carácter `c` aparece al menos una vez en `s`.
