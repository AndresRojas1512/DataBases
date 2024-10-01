import psycopg2
from faker import Faker
from faker_vehicle import VehicleProvider


connParams = {
    "dbname" : "cars01",
    "user" : "postgres",
    "password" : "andresrmlnx15",
    "host" : "localhost",
    "port" : "5432"
}

def connectToDatabase():
    try:
        conn = psycopg2.connect(**connParams)
        print("Connection established successfully.")

        cur = conn.cursor()
        
        cur.execute("SELECT NOW();")
        result = cur.fetchone()
        print("Current time from the database:", result)

        cur.execute("""
        SELECT table_name 
        FROM information_schema.tables 
        WHERE table_schema = 'public'
        """)
        
        tables = cur.fetchall()
        print("Available tables in the database:")
        for table in tables:
            print(table[0])
        
        cur.close()
        conn.close()
        
    except Exception as e:
        print("An error occurred while connecting to the database:", e)

if __name__ == "__main__":
    f = Faker()
    f.add_provider(VehicleProvider)
    for i in range(1000):
        print(f.vehicle_make())
    connectToDatabase()