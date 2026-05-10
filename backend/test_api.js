const email = 'test_user_' + Date.now() + '@example.com';
const password = 'securepassword123';

async function testApi() {
  console.log('--- Testing API Endpoints ---');
  
  // 1. Register User
  console.log('\n1. Registering user...');
  try {
    const regRes = await fetch('http://localhost:3000/api/auth/register', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        full_name: 'Test User',
        email: email,
        password: password
      })
    });
    const regData = await regRes.json();
    console.log('Register Status:', regRes.status);
    console.log('Register Response:', regData);
  } catch (err) {
    console.error('Register failed:', err);
  }

  // 2. Login User
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
    console.log('Login Response:', loginData);
  } catch (err) {
    console.error('Login failed:', err);
  }

  // 3. Login with wrong password
  console.log('\n3. Logging in with wrong password...');
  try {
    const wrongLoginRes = await fetch('http://localhost:3000/api/auth/login', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        email: email,
        password: 'wrongpassword'
      })
    });
    const wrongLoginData = await wrongLoginRes.json();
    console.log('Wrong Login Status:', wrongLoginRes.status);
    console.log('Wrong Login Response:', wrongLoginData);
  } catch (err) {
    console.error('Wrong Login failed:', err);
  }
}

testApi();
