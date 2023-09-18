import flatbuffers
import client_generated  # Import the generated Python module (client_generated.py)

# Read the binary data from the file
with open("person_data.bin", "rb") as file:
    data = file.read()

# Create a FlatBuffers buffer from the data
buf = flatbuffers.binary_buffer.Buffer(data)

# Deserialize the Client object (which can be either a Person or a Group)
client = person_generated.Client.GetRootAsClient(buf, 0)

if client.ClientType() == person_generated.Client_Person:
    person = client.Client(person_generated.Person())  # Access the Person object
    name = person.Name().decode('utf-8')  # Decoding from bytes to string
    age = person.Age()
    weight = person.Weight()
    gender = person.Gender().decode('utf-8')
    print(f"Person: Name={name}, Age={age}, Weight={weight}, Gender={gender}")
elif client.ClientType() == person_generated.Client_Group:
    group = client.Client(person_generated.Group())  
    group_name = group.Name().decode('utf-8')
    avg_age = group.AverageAge()
    avg_weight = group.AverageWeight()
    names = [name.decode('utf-8') for name in group.NamesList()]
    print(f"Group: Name={group_name}, Average Age={avg_age}, Average Weight={avg_weight}, Names={', '.join(names)}")
