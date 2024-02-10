% Лабораторная работа № 1.1. Раскрутка самоприменимого компилятора
% 14 февраля 2023 г.
% Самохвалова Полина, ИУ9-62Б

# Цель работы
Целью данной работы является ознакомление с раскруткой самоприменимых компиляторов на примере модельного 
компилятора.

# Индивидуальный вариант
Компилятор BeRo. Сделать так, чтобы целочисленные константы, выходящие за границы допустимого интервала, 
считались равными нулю.

# Реализация

Различие между файлами `btpc64.pas` и `btpc64-2.pas`:

```diff
--- btpc64.pas	2020-02-15 14:28:08.000000000 +0300
+++ btpc64-2.pas	2023-02-12 03:28:27.893369472 +0300
@@ -1991,28 +1991,44 @@
 procedure EmitInt16(i..integer);
 begin
  if i>=0 then begin
+  if i > 32767 then
+    i := 0;
   EmitByte(i mod 256);
   EmitByte((i div 256) mod 256);
  end else begin
-  i:=-(i+1);
-  EmitByte(255-(i mod 256));
-  EmitByte(255-((i div 256) mod 256));
+   if i < -32768 then begin
+     EmitByte(0);
+     EmitByte(0)
+   end else begin
+     i:= -(i+1);
+     EmitByte(255-(i mod 256));
+     EmitByte(255-((i div 256) mod 256));
+   end;
  end;
 end;
 
 procedure EmitInt32(i..integer);
 begin
  if i>=0 then begin
-  EmitByte(i mod 256);
-  EmitByte((i div 256) mod 256);
-  EmitByte((i div 65536) mod 256);
-  EmitByte(i div 16777216);
+   if i > 2147483647 then
+     i := 0;
+   EmitByte(i mod 256);
+   EmitByte((i div 256) mod 256);
+   EmitByte((i div 65536) mod 256);
+   EmitByte(i div 16777216);
  end else begin
-  i:=-(i+1);
-  EmitByte(255-(i mod 256));
-  EmitByte(255-((i div 256) mod 256));
-  EmitByte(255-((i div 65536) mod 256));
-  EmitByte(255-(i div 16777216));
+   if i < -2147483648 then begin
+     EmitByte(0);
+     EmitByte(0);
+     EmitByte(0);
+     EmitByte(0)
+   end else begin
+     i:= -(i+1);
+     EmitByte(255-(i mod 256));
+     EmitByte(255-((i div 256) mod 256));
+     EmitByte(255-((i div 65536) mod 256));
+     EmitByte(255-(i div 16777216));
+   end;
  end;
 end;
```

Различие между файлами `btpc64-2.pas` и `btpc64-3.pas`:

```diff
--- btpc64-2.pas	2023-02-12 03:28:27.893369472 +0300
+++ btpc64-3.pas	2023-02-14 13:17:39.427885580 +0300
@@ -2011,7 +2011,7 @@
 begin
  if i>=0 then begin
    if i > 2147483647 then
-     i := 0;
+     i := 2147483648;
    EmitByte(i mod 256);
    EmitByte((i div 256) mod 256);
    EmitByte((i div 65536) mod 256);
```

# Тестирование

Тестовый пример:

```pascal
program myprog;

var n: integer;

begin
  n := 37;
  writeln(n);
  n := 2147483647;
  writeln(n);
  n := 2147483648;
  writeln(n);
  n := -10;
  writeln(n);
  n := -2147483648;
  writeln(n);
  n := -2147483649;
  writeln(n);
  n := 100;
  writeln(n);
  n := 1000000000000000000000;
  writeln(n);
end.
```

Вывод тестового примера на `stdout`

```
37
2147483647
0
-10
-2147483648
0
100
0
```

# Вывод

В результате выполнения лабораторной работы было осуществлено ознакомление с раскруткой самоприменимых 
компиляторов на примере модельного компилятора, в компиляторе BeRo было сделано так, чтобы целочисленные 
константы, выходящие за границы допустимого интервала, считались равными нулю.