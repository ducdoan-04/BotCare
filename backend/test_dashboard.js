const email = 'test_dashboard_user_' + Date.now() + '@example.com';
const password = 'securepassword123';

async function testDashboard() {
  console.log('=== Testing Dashboard API with Authentication ===\n');

  let token = '';

  // Step 1: Register
  console.log('1. Registering new user...');
  try {
    const regRes = await fetch('http://localhost:3000/api/auth/register', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        full_name: 'Dashboard Tester',
        email: email,
        password: password
      })
    });
    console.log('Register Status:', regRes.status);
  } catch (err) {
    console.error('Register failed:', err);
    return;
  }

  // Step 2: Login to get token
  console.log('\n2. Logging in...');
  try {
    const loginRes = await fetch('http://localhost:3000/api/auth/login', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        email: email,
        password: password
      })
    });
    const loginData = await loginRes.json();
    console.log('Login Status:', loginRes.status);
    token = loginData.accessToken;
    console.log('Token acquired (first 25 chars):', token.substring(0, 25) + '...');
  } catch (err) {
    console.error('Login failed:', err);
    return;
  }

  // Step 3: Call Dashboard with NO token (should be 401)
  console.log('\n3. Fetching dashboard WITHOUT authorization header...');
  try {
    const res = await fetch('http://localhost:3000/api/v1/dashboard', {
      method: 'GET'
    });
    const data = await res.json();
    console.log('Status (expected 401):', res.status);
    console.log('Response:', data);
  } catch (err) {
    console.error('No-token fetch failed:', err);
  }

  // Step 4: Call Dashboard with token (should succeed, default today/week)
  console.log('\n4. Fetching dashboard WITH authorization header (period=week)...');
  try {
    const res = await fetch('http://localhost:3000/api/v1/dashboard?period=week', {
      method: 'GET',
      headers: {
        'Authorization': `Bearer ${token}`
      }
    });
    const result = await res.json();
    console.log('Status (expected 200):', res.status);
    console.log('Data structure matches standard response:', result.success);
    console.log('\nSample Summary Output:');
    console.log(JSON.stringify(result.data.summary, null, 2));
    
    console.log('\nSample Chart Output:');
    console.log(JSON.stringify(result.data.patient_chart, null, 2));
    
    console.log('\nSample Polyclinics Bar Chart Output:');
    console.log(JSON.stringify(result.data.polyclinics, null, 2));

    console.log('\nSample Upcoming Appointments Output:');
    console.log(JSON.stringify(result.data.upcoming_appointments[0], null, 2));
  } catch (err) {
    console.error('Authorized fetch failed:', err);
  }
}

testDashboard();
