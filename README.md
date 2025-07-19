# Task List Manager (Ruby CLI)

A command-line Ruby application for managing daily task lists using either:
-  **Local file storage (JSON)**
-  **Remote MongoDB database**

> 💡 *This is a personal project built to further explore the capabilities of the Ruby programming language and to deepen understanding of working with MongoDB in real-world applications.*  

> ⚠️ *This app is not intended for production use or serious task management — it's strictly for educational and experimental purposes.*

## ✨ Features

- View, add, mark, and delete tasks
- Store data locally in JSON format
- Store data remotely in a MongoDB collection
- Interactive CLI using `tty-prompt`
- Color-coded messages for a pleasant UX

---

## 📋 Requirements

- Ruby 3.4+
- Bundler (`gem install bundler`)
- MongoDB URI (if using remote mode)
- `.env` file for MongoDB credentials (optional)

---

## 📦 Gems Used

- `mongo`
- `dotenv`
- `tty-prompt`
- `colorize`
- `json` (built-in)
- `date` (built-in)

---

## ⚙️ Setup

1. **Clone this repository**:

```bash
git clone https://github.com/daviddluci/Task-List
cd Task-List
```

2. **Install dependencies**:

Make sure you have [Bundler](https://bundler.io/) installed:

```bash
gem install bundler
```

Then install the required gems:

```bash
bundle install
```

3. **Edit the .env file (Optional, only for MongoDB use)**

`.env` file should hold a variable in format like this:

```bash
db_uri=mongodb+srv://your_username:your_password@your_cluster_name.mongodb.net/collection_name?retryWrites=true&w=majority
```

This URI allows the app to connect to your remote MongoDB cluster.
If you don't have a Cluster yet and would like to try out the features, there is a MongoDB uri already provided for testing purposes.

There is also an option to provide MongoDB URI in real-time while running the app.

## 🚀 Running the App

To start the CLI application, run:

```bash
ruby main.rb
```

You will be asked to choose between:

- **Local Storage Mode**
- **Remote Database Mode**
- **Exit**

Choose the mode and follow the instructions!

## 📂 Local Data Storage

- Task lists are saved as JSON files inside the `/local_data` directory.

- File name format: `YYYY-MM-DD.json`

## 🌐 Remote MongoDB Usage
- Tasks are stored in the `task_list` collection of the specified MongoDB database.

- You can add, view, update, and delete tasks using interactive prompts.

# ✅ All set!

You're ready to manage your tasks with style and structure.
Enjoy your productivity boost with this Ruby CLI app!