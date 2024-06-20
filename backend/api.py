from flask import Flask, request, jsonify
import mysql.connector

app = Flask(__name__)


# Database connection
def get_db_connection():
    return mysql.connector.connect(
        host="localhost",
        port=3306,
        user="root",
        password="***********",
        database="*******",
    )


# API to verify user
@app.route("/verify_user", methods=["POST"])
def verify_user():
    data = request.json
    username = data.get("username")

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM users WHERE username = %s", (username,))
    user = cursor.fetchone()
    cursor.close()
    conn.close()

    if user:
        return jsonify({"status": "success", "user": user})
    else:
        return jsonify({"status": "failure"}), 401


@app.route("/create_user", methods=["POST"])
def create_user():
    data = request.get_json()
    username = data["username"]
    age = data["age"]
    gender = data["gender"]
    cur = mysql.connection.cursor()
    cur.execute(
        "INSERT INTO users (username, age, gender) VALUES (%s, %s, %s)",
        (username, age, gender),
    )
    mysql.connection.commit()
    cur.close()
    return jsonify(
        {
            "status": "success",
            "user": {"username": username, "age": age, "gender": gender},
        }
    )


# Add user
@app.route("/add_user", methods=["POST"])
def add_user():
    data = request.get_json()
    connection = create_connection()
    cursor = connection.cursor()
    cursor.execute(
        "INSERT INTO users (username, age, gender) VALUES (%s, %s, %s)",
        (data["username"], data["age"], data["gender"]),
    )
    connection.commit()
    return jsonify({"status": "success"}), 201


# Add task
@app.route("/add_task", methods=["POST"])
def add_task():
    data = request.get_json()
    print
    connection = get_db_connection()
    cursor = connection.cursor()
    cursor.execute(
        "INSERT INTO tasks (user_id, name, description, isCompleted, deadline, priority) VALUES (%s, %s, %s, %s, %s, %s)",
        (
            data["user_id"],
            data["name"],
            data["description"],
            data["isCompleted"],
            data["deadline"][0:10],
            data["priority"],
        ),
    )
    connection.commit()
    return jsonify({"status": "success"}), 201


# Fetch tasks for a user
@app.route("/get_tasks", methods=["GET"])
def get_tasks():
    user_id = request.args.get("user_id")
    connection = get_db_connection()
    cursor = connection.cursor(dictionary=True)
    cursor.execute("SELECT * FROM tasks WHERE user_id = %s", (user_id,))
    tasks = cursor.fetchall()
    return jsonify(tasks), 200


# Remove a task
@app.route("/remove_task", methods=["POST"])
def remove_task():
    conn = get_db_connection()
    if not conn:
        return jsonify({"error": "Database connection error"}), 500

    data = request.get_json()
    user_id = data.get("user_id")
    task_name = data.get("task_name")
    print(user_id)
    print(task_name)

    try:
        cursor = conn.cursor()
        cursor.execute(
            "DELETE FROM tasks WHERE user_id = %s AND name = %s", (user_id, task_name)
        )
        conn.commit()
        cursor.close()
        conn.close()
        return jsonify({"message": "Task removed successfully"}), 200
    except Error as e:
        print(e)
        return jsonify({"error": "Failed to remove task"}), 500


# Update task completion status
@app.route("/update_task_completion", methods=["POST"])
def update_task_completion():
    task_id = request.json["task_id"]
    is_completed = request.json["isCompleted"]
    connection = get_db_connection()
    cursor = connection.cursor()
    cursor.execute(
        "UPDATE tasks SET isCompleted = %s WHERE id = %s", (is_completed, task_id)
    )
    connection.commit()
    return jsonify({"status": "success"}), 200


if __name__ == "__main__":
    app.run(debug=True)
