()
// RUN: %sourcekitd-test -req=complete -pos=1:2 %s -- %s | FileCheck %s -check-prefix=KEYWORDS
// RUN: %sourcekitd-test -req=complete.open -pos=1:2 %s -- %s | FileCheck %s -check-prefix=LITERALS

// KEYWORDS-NOT: source.lang.swift.literal
// KEYWORDS: key.name: "nil"
// KEYWORDS-NOT: source.lang.swift.literal
// LITERALS: key.kind: source.lang.swift.literal.string
// LITERALS: key.sourcetext: "\"<#{{.*}}#>\""
// LITERALS: key.kind: source.lang.swift.literal.boolean
// LITERALS: key.kind: source.lang.swift.literal.array
// LITERALS: key.sourcetext: "[<#{{.*}}#>]"
// LITERALS: key.kind: source.lang.swift.literal.dictionary
// LITERALS: key.sourcetext: "[<#{{.*}}#>: <#{{.*}}#>]"
// LITERALS: key.kind: source.lang.swift.literal.tuple
// LITERALS: key.sourcetext: "(<#{{.*}}#>)"
// LITERALS: key.kind: source.lang.swift.literal.nil

// RUN: %complete-test -tok=STMT1 %s -raw | FileCheck %s -check-prefix=STMT
// RUN: %complete-test -tok=STMT2 %s -raw | FileCheck %s -check-prefix=STMT
// RUN: %complete-test -tok=STMT3 %s -raw | FileCheck %s -check-prefix=STMT
// STMT-NOT: source.lang.swift.literal

#^STMT1^#

if true {
  #^STMT2^#
}
func foo(_ x: Int) {
  #^STMT3^#
}

// RUN: %complete-test -tok=EXPR1 %s -raw | FileCheck %s -check-prefix=LITERALS
// RUN: %complete-test -tok=EXPR2 %s -raw | FileCheck %s -check-prefix=LITERALS
// RUN: %complete-test -tok=EXPR3 %s -raw | FileCheck %s -check-prefix=LITERALS
let x1 = #^EXPR1^#
x1 + #^EXPR2^#
if #^EXPR3^# { }

// RUN: %complete-test -tok=EXPR4 %s -raw | FileCheck %s -check-prefix=LITERAL_INT
foo(#^EXPR4^#)
// LITERAL_INT-NOT: source.lang.swift.literal
// LITERAL_INT: key.kind: source.lang.swift.literal.integer
// LITERAL_INT-NOT: source.lang.swift.literal

// RUN: %complete-test -tok=EXPR5 %s -raw | FileCheck %s -check-prefix=LITERAL_TUPLE
let x2: (String, Int) = #^EXPR5^#
// LITERAL_TUPLE-NOT: source.lang.swift.literal
// LITERAL_TUPLE: key.kind: source.lang.swift.literal.tuple
// LITERAL_TUPLE-NOT: source.lang.swift.literal

// RUN: %complete-test -tok=EXPR6 %s -raw | FileCheck %s -check-prefix=LITERAL_NO_TYPE
// When there is a type context that doesn't match, we should see no literals
// except the keywords and they should be prioritized like keywords not
// literals.
struct Opaque {}
let x3: Opaque = #^EXPR6,,colo,ni,tru,fals^#
// LITERAL_NO_TYPE-LABEL: Results for filterText:  [
// LITERAL_NO_TYPE-NOT: source.lang.swift.literal
// LITERAL_NO_TYPE: ]
// LITERAL_NO_TYPE-LABEL: Results for filterText: colo [
// LITERAL_NO_TYPE-NOT: source.lang.swift.literal
// LITERAL_NO_TYPE: ]
// LITERAL_NO_TYPE-LABEL: Results for filterText: ni [
// LITERAL_NO_TYPE-NOT: source.lang.swift.literal
// LITERAL_NO_TYPE: key.kind: source.lang.swift.literal.nil
// LITERAL_NO_TYPE-NOT: source.lang.swift.literal
// LITERAL_NO_TYPE: ]
// LITERAL_NO_TYPE-LABEL: Results for filterText: tru [
// LITERAL_NO_TYPE-NOT: source.lang.swift.literal
// LITERAL_NO_TYPE: key.kind: source.lang.swift.literal.boolean
// LITERAL_NO_TYPE-NOT: source.lang.swift.literal
// LITERAL_NO_TYPE: ]
// LITERAL_NO_TYPE-LABEL: Results for filterText: fals [
// LITERAL_NO_TYPE-NOT: source.lang.swift.literal
// LITERAL_NO_TYPE: key.kind: source.lang.swift.literal.boolean
// LITERAL_NO_TYPE-NOT: source.lang.swift.literal
// LITERAL_NO_TYPE: ]
