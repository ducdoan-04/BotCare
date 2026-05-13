const BASE_URL = 'http://localhost:3000/api/v1';

async function testCreateStaff() {
  try {
    // 1. Get Token
    const loginRes = await fetch('http://localhost:3000/api/auth/login', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ email: 'receptionist@carebot.com', password: 'password123' })
    });
    const { accessToken } = await loginRes.json();

    // 2. Create Staff via Multipart-like Fetch (Simulated)
    // Node 18+ has native FormData
    const formData = new FormData();
    formData.append('full_name', 'Johan Smith');
    formData.append('email', `johan.smith.${Date.now()}@example.com`);
    formData.append('role', 'Pharmacist');
    formData.append('gender', 'Male');
    formData.append('address', '123 Pharmacy St, Birmingham');
    formData.append('country', 'UK');
    formData.append('state', 'West Midlands');
    formData.append('city', 'Birmingham');
    formData.append('postal_code', 'B1 1BD');
    formData.append('joining_date', '2025-02-09');
    formData.append('professional_summary', 'Johan is a dedicated and detail-oriented pharmacist with over 6 years of experience.');

    const createRes = await fetch(`${BASE_URL}/staff`, {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${accessToken}`
      },
      body: formData
    });

    const result = await createRes.json();
    console.log('--- CREATE STAFF RESULT ---');
    console.log(JSON.stringify(result, null, 2));

    if (result.success) {
      console.log('\nSUCCESS: Staff created successfully via Terminal!');
    } else {
      console.log('\nFAILED: ' + result.error);
    }
  } catch (error) {
    console.error('ERROR:', error.message);
  }
}

testCreateStaff();
