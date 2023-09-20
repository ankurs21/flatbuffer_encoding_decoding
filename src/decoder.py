import sys
import flatbuffers

# Add the directory containing generated Python files to the Python path
sys.path.append("generated")

import MyData.Client as Client
import MyData.Group as Group
import MyData.Person as Person
import MyData.ClientData as ClientData

# Read the binary data from the file
with open("clients.bin", "rb") as file:
    data = file.read()

offset = 0
while offset < len(data):

    # Deserialize the data
    client = Client.Client().GetRootAs(data,offset);

    client_data = client;
    if client_data is not None:
        print(client.ClientType())
        if client_data.ClientType() == ClientData.ClientData().Person:
            person = Person.Person()
            person.Init(client_data.Client().Bytes, client_data.Client().Pos)
            print(client_data.Client().Pos)
            print("Person:")
            print(f"Name: {person.Name().decode('utf-8')}")
            print(f"Age: {person.Age()}")
            print(f"Weight: {person.Weight()}")
            print(f"Gender: {person.Gender().decode('utf-8')}")
        elif client_data.ClientType() == ClientData.ClientData().Group:
            group = Group.Group()
            group.Init(client_data.Client().Bytes, client_data.Client().Pos)
            print("Group:")
            print(f"GroupName: {group.GroupName().decode('utf-8')}")
            print(f"AverageAge: {group.AverageAge()}")
            print(f"AverageWeight: {group.AverageWeight()}")
            print("Names in Group:")
            for i in range(group.NamesLength()):
                names = group.Names(i)
                #name = names.Get(i).decode('utf-8')
                print(f"Name {i + 1}: {names}")
        else:
            print("Unknown type")

        offset += client.Client().Pos

    else:
