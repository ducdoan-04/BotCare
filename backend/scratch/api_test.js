const BASE_URL = 'http://localhost:3000/api/v1';
let token = '';

async function runTests() {
  try {
    console.log('--- 1. Testing Login ---');
    const loginRes = await fetch(`${BASE_URL}/auth/login`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        email: 'receptionist@carebot.com',
        password: 'password123'
      })
    });
    const loginData = await loginRes.json();
    token = loginData.accessToken;
    if (!token) throw new Error('Login failed: ' + JSON.stringify(loginData));
    console.log('Login Success!');

    const headers = { 
      'Authorization': `Bearer ${token}`,
      'Content-Type': 'application/json'
    };

    console.log('\n--- 2. Testing Dashboard ---');
    const dashboardRes = await fetch(`${BASE_URL}/dashboard`, { headers });
    const dashboardData = await dashboardRes.json();
    console.log('Dashboard Summary:', dashboardData.data.summary);

    console.log('\n--- 3. Testing List Patients ---');
    const patientsRes = await fetch(`${BASE_URL}/patients`, { headers });
    const patientsData = await patientsRes.json();
    console.log(`Found ${patientsData.data.length} patients.`);

    console.log('\n--- 4. Testing Create Patient ---');
    const createRes = await fetch(`${BASE_URL}/patients`, {
      method: 'POST',
      headers,
      body: JSON.stringify({
        full_name: 'Test CMD Patient',
        email: 'cmd_test@example.com',
        status: 'Under Treatment'
      })
    });
    const createData = await createRes.json();
    const newId = createData.data.id;
    console.log('Create Success! New ID:', newId);

    console.log('\n--- 5. Testing Update Patient (Partial) ---');
    const updateRes = await fetch(`${BASE_URL}/patients/${newId}`, {
      method: 'PUT',
      headers,
      body: JSON.stringify({
        status: 'Recovered',
        blood_type: 'O+'
      })
    });
    const updateData = await updateRes.json();
    console.log('Update Success! New status:', updateData.data.status);

    console.log('\n--- 6. Testing List Doctors ---');
    const doctorsRes = await fetch(`${BASE_URL}/doctors`, { headers });
    const doctorsData = await doctorsRes.json();
    console.log(`Found ${doctorsData.data.length} doctors.`);

    console.log('\n--- ALL TESTS PASSED SUCCESSFULLY ---');
  } catch (error) {
    console.error('\n--- TEST FAILED ---');
    console.error(error.message);
    process.exit(1);
  }
}

runTests();
