# 📊 Habit Tracker – "Consistently"

Track your habits, build streaks, and stay consistent. This is a full-stack Ruby on Rails application designed to help users track personal goals with a visual and interactive calendar.

---

## ✅ Features

- 🔐 User Authentication using **Devise**
- ➕ Add/Edit/Delete Habits
- 📅 Calendar UI with TailwindCSS
- ✅ Check-in for any day
- 📈 Stats: **Current Streak**, **Longest Streak**, **Consistency %**
- ⚡ Live UI updates using **Hotwire (Turbo + Stimulus)**
- 📨 Weekly summary emails via **ActionMailer + Sidekiq + sidekiq-cron**
- 📱 Mobile responsive UI with **Tailwind CSS**

---

## 🧰 Tech Stack

- **Ruby:** 3.2+
- **Rails:** 8.x
- **Database:** PostgreSQL
- **Frontend:** Tailwind CSS, Hotwire (Turbo/Stimulus)
- **Background Jobs:** Sidekiq + Redis
- **Authentication:** Devise

---

## 💻 System Dependencies

- Ruby 3.2+
- PostgreSQL
- Node.js + Yarn
- Redis (for background job processing)
- ImageMagick (for optional file/image processing)

---

## ⚙️ Setup Instructions

```bash
# Clone the repository
git clone https://github.com/Truptipawar28/habit-tracker.git
cd habit-tracker

# Install Ruby gems
bundle install

# Install frontend packages
yarn install

# Setup the database
rails db:setup

# Start Sidekiq (in a separate terminal)
bundle exec sidekiq

# Start the app
bin/dev

🧪 Running the Test Suite
rails test 

📬 Email + Background Jobs
Email summaries are sent weekly via a Sidekiq Cron job.

Configure sidekiq-cron in config/schedule.yml and ensure Redis is running.