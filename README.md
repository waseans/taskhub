Sure! Here's a clean, emoji-free version of the `README.md` content:

---

# TaskHub

TaskHub is a task management application built using Flutter and Supabase. It features a dark-themed user interface and allows users to add, view, delete, and manage tasks. Additional features include calendar view, notifications, and chat.

---

## Setup Instructions

### Prerequisites

- Flutter SDK (latest stable version)
- Dart SDK
- Supabase account
- Android Studio or Visual Studio Code with Flutter plugins
- A physical device or emulator

### Local Setup

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/taskhub.git
   cd taskhub
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Set up environment variables (if used):
   - Create a `.env` file or directly configure in code.
   - Add your Supabase credentials:
     ```
     SUPABASE_URL=your-supabase-url
     SUPABASE_ANON_KEY=your-anon-key
     ```

4. Run the app:
   ```bash
   flutter run
   ```

---

## Supabase Setup Steps

1. Sign in at [supabase.io](https://supabase.io) and create a new project.

2. Retrieve your project’s URL and anon public key.

3. Create a table named `tasks` with the following structure:

   | Column Name   | Type     | Description                      |
   |---------------|----------|----------------------------------|
   | id            | UUID     | Primary key                      |
   | user_id       | UUID     | Foreign key (from auth)          |
   | title         | Text     | Task title                       |
   | description   | Text     | Task description (optional)      |
   | is_completed  | Boolean  | Whether the task is complete     |
   | due_date      | Date     | Optional due date                |
   | priority      | Text     | Task priority (e.g., High, Low)  |
   | created_at    | Timestamp| Auto-generated when created      |

4. Enable Row Level Security (RLS).

5. Create access policies to allow read and write access for authenticated users.



## Hot Reload vs Hot Restart

| Feature         | Hot Reload                                 | Hot Restart                            |
|-----------------|---------------------------------------------|-----------------------------------------|
| Performance     | Fast, quick rebuild                         | Slightly slower than hot reload         |
| UI State        | Maintains current UI state                  | Clears and resets app state             |
| Use Case        | Small UI and logic changes                  | Initialization or state-related changes |
| Rebuild Scope   | Partial, updates only affected widgets      | Full rebuild from the `main()` method   |

Use hot reload for UI adjustments. Use hot restart when making changes to state or startup logic.
