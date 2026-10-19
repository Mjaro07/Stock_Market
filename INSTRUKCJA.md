# Dziennik Tradera – instrukcja uruchomienia

Zajmie Ci to około 20 minut i jest całkowicie darmowe. Potrzebujesz dwóch kont: **Supabase** (tam są dane) i **GitHub** (stamtąd działa strona).

Pliki w paczce:

| Plik | Do czego służy |
|---|---|
| `index.html` | sama aplikacja |
| `config.js` | tu wklejasz dane swojej bazy (krok 1.5) |
| `supabase.sql` | tworzy tabelę w bazie (krok 1.3) |
| `manifest.json`, `sw.js`, `icon-*.png` | instalacja jako aplikacja i ikona |
| `dziennik-kopia-start.json` | Twoje 12 transakcji z XTB z notatkami, do wczytania na start |

---

## 1. Baza danych (Supabase)

1. Wejdź na **supabase.com** → *Start your project* → zaloguj się (najprościej przez GitHub).
2. *New project*: wpisz nazwę `dziennik`, wymyśl hasło do bazy (zapisz je gdzieś, ale do aplikacji nie będzie potrzebne), region **Central EU (Frankfurt)**. Kliknij *Create* i poczekaj około 2 minut.
3. Z lewego menu wybierz **SQL Editor** → *New query*. Otwórz plik `supabase.sql`, skopiuj całą zawartość, wklej i kliknij **Run**. Powinno pojawić się „Success”.
4. Z lewego menu wybierz **Project Settings** (zębatka) → **API** (lub *Data API* i *API Keys*). Potrzebujesz dwóch rzeczy:
   - **Project URL**, np. `https://abcdefgh.supabase.co`
   - klucz **anon public**, czyli długi tekst zaczynający się od `eyJ...`
5. Otwórz `config.js` w Notatniku i wklej te dwie wartości między cudzysłowy:
   ```js
   supabaseUrl: "https://abcdefgh.supabase.co",
   supabaseAnonKey: "eyJhbGciOi..."
   ```
   Zapisz plik.

> Klucz „anon public” może być widoczny publicznie. Twoich danych pilnuje logowanie i reguły z `supabase.sql`, więc nikt poza Tobą nie zobaczy Twoich transakcji. **Nigdy** nie wklejaj klucza `service_role`.

## 2. Strona (GitHub Pages)

1. Wejdź na **github.com** i załóż konto, jeśli go nie masz.
2. Kliknij **+** (prawy górny róg) → *New repository*. Nazwa: `dziennik`, widoczność **Public** (darmowe Pages tego wymaga, ale Twoje dane są w Supabase, nie tutaj). Kliknij *Create repository*.
3. Kliknij link *uploading an existing file*. Przeciągnij **wszystkie pliki** z folderu (z uzupełnionym `config.js`) i kliknij **Commit changes**.
4. Przejdź do **Settings** → **Pages**. W *Source* wybierz *Deploy from a branch*, a w *Branch* wybierz `main` i `/ (root)`. Kliknij **Save**.
5. Po 1–2 minutach na górze tej strony pojawi się adres, np. `https://twojlogin.github.io/dziennik/`. To jest Twoja aplikacja.

## 3. Ustaw adres w Supabase (ważne dla maila potwierdzającego)

W Supabase wybierz **Authentication** → **URL Configuration** i w **Site URL** wpisz adres z kroku 2.5, np. `https://twojlogin.github.io/dziennik/`. Kliknij *Save*.

## 4. Pierwsze uruchomienie

1. Otwórz swój adres i kliknij **Załóż konto** (e-mail i hasło).
2. Kliknij link w mailu od Supabase, wróć do aplikacji i zaloguj się.
3. W sekcji *Kopia zapasowa* kliknij **Wczytaj kopię** i wybierz `dziennik-kopia-start.json`. Pojawi się Twoje 12 transakcji z notatkami.

## 5. Zainstaluj jako aplikację

- **Chrome:** w pasku adresu pojawi się ikonka instalacji (monitor ze strzałką). Możesz też otworzyć menu ⋮ → *Zapisz i udostępnij* → *Zainstaluj stronę jako aplikację*.
- **Edge:** menu … → *Aplikacje* → *Zainstaluj tę witrynę jako aplikację*.
- **iPhone (Safari):** *Udostępnij* → *Do ekranu początkowego*.
- **Android (Chrome):** ⋮ → *Zainstaluj aplikację* / *Dodaj do ekranu głównego*.

Na drugim komputerze otwórz ten sam adres, zaloguj się tym samym e-mailem i zainstaluj aplikację. Dane są wspólne.

---

## Na co dzień

- **Nowe transakcje z XTB:** w xStation wybierz *Historia konta* → *Eksportuj* (.xlsx), a potem w aplikacji *Import z XTB*. Dodadzą się tylko nowe pozycje, a Twoje notatki zostaną.
- **Transakcja ze screena:** zrób zrzut okna *Szczegóły pozycji* (najlepiej, bo jest tam dokładny wynik, SL i TP) albo wiersza z *Historii* w xStation i wklej go w aplikacji (Ctrl+V), przeciągnij albo kliknij *Screen*. Pola wypełnią się same, a Ty sprawdzasz je i klikasz *Zapisz*. Wklejony zrzut wykresu (np. z TradingView) doczepi się do otwartej transakcji. Ze screena samego wiersza wynik PLN jest szacunkiem i poprawi się sam przy imporcie pliku z XTB. Wymaga jednorazowego uruchomienia `supabase-screeny.sql`.
- **Notatki:** kliknij wiersz w tabeli, dopisz setup, emocje i to, czy złamałeś zasadę, a potem kliknij *Zapisz*.
- **Kopia zapasowa:** raz w miesiącu kliknij *Pobierz kopię (.json)*.
- **Zmiana aplikacji** (np. innych zasad): edytujesz `index.html` na GitHubie (ikona ołówka) i klikasz *Commit*. Strona zaktualizuje się po około minucie.

## Gdy coś nie działa

- **„Aplikacja nie jest jeszcze połączona z bazą”**: `config.js` jest pusty albo ma literówkę. Sprawdź cudzysłowy i przecinki.
- **„Zły e-mail lub hasło”** zaraz po rejestracji: najpierw kliknij link w mailu potwierdzającym.
- **Link z maila prowadzi do `localhost`**: wróć do kroku 3.
- **Błąd przy zapisie typu `relation "trades" does not exist`**: plik `supabase.sql` nie został uruchomiony (krok 1.3).
- **Supabase wstrzymał projekt**: darmowy projekt po 7 dniach bez używania jest pauzowany. Wejdź na supabase.com i kliknij *Restore*. Dane zostają.
