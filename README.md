# EjercicioDevOpsNttData

## **Descripción**
Este microservicio REST expone un único endpoint `/DevOps` que acepta solicitudes HTTP **POST** con un JSON específico y responde con un mensaje de confirmación. Se ha diseñado para cumplir con los requisitos de seguridad, despliegue y escalabilidad especificados en el reto técnico. A continuación de muestra la arquitectura planteada:

![alt text](image.png)


---

## **Tecnologías Utilizadas**
- **Node.js y Express.js** para el desarrollo del microservicio.
- **JWT (jsonwebtoken)** para autenticación basada en tokens.
- **Docker** para contenerización.
- **terraform** como infraestructura como código.
- **GitHub Actions** para automatización de pruebas y despliegue.
- **Jest** para pruebas automatizadas (unitarias y de integración).




---

## **Implementación del Endpoint `/DevOps`**
### **Requisitos Implementados**
✔️ **Acepta solo solicitudes `POST` con JSON válido.**  
✔️ **Valida la API Key en el header `X-Parse-REST-API-Key`.**   
✔️ **Maneja métodos no permitidos devolviendo `ERROR`.**  
✔️ **Incluye un balanceador de carga con al menos 2 nodos.**  
✔️ **Es completamente containerizado y desplegable en cualquier nube.**  

### **Ejemplo de Solicitud Válida**
```bash
curl --location 'http://prueba-alb-456457147.us-east-1.elb.amazonaws.com/DevOps' \
--header 'X-Parse-REST-API-Key: 2f5ae96c-b558-4c7b-a590-a501ae1c3f6c' \
--header 'X-JWT-KWY: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0byI6Ikp1YW4iLCJmcm9tIjoiTWFyaWEiLCJpYXQiOjE3NDA1NjQ3NTN9.8pAF1bnIQ3sfVTULkNz0MVtYZDvvktH9s3HSKGy7mO0' \
--header 'Content-Type: application/json' \
--data '{ "message": "This is a test", "to": "Juan Perez", "from": "Rita Asturia", "timeToLifeSec": 45 }'
```

### **Ejemplo de Respuesta**
```json
{
  "message": "Hello Juan Perez your message will be sent"
}
```

---

## **Despliegue y Contenerización**
### **Ejecución en Local**
```bash
npm install
npm start
```

### **Construcción del Contenedor Docker**
```bash
docker build -t devops-microservice .
docker run -p 8080:8080 devops-microservice
```

---

## **Pipeline CI/CD**
El flujo de integración y despliegue incluye:

### **Etapas del Pipeline**
1. **Build**: Instala dependencias y verifica la estructura del código.
2. **Test**: Ejecuta pruebas automatizadas con **Jest**.


### **Ejemplo de Pipeline en GitHub Actions**
```yaml
name: Prueba técnica NttData

on:
  push:
    branches: [ master ]
permissions:
  id-token: write
  contents: read

jobs:

  deploy:
    name: Build
    runs-on: ubuntu-latest
    environment: production

    steps:
    - name: Checkout
      uses: actions/checkout@v4

    - name: Setup Terraform
      uses: hashicorp/setup-terraform@v2
      with:
          terraform_version: "1.3.0"     

    - name: Terraform Init
      working-directory: terraform
      run: terraform init

    - name: Terraform Plan
      working-directory: terraform
      run: terraform plan -var "access_key=${{ secrets.AWS_ACCESS_KEY_ID }}" -var "secret_key=${{ secrets.AWS_SECRET_ACCESS_KEY }}" -var "region=${{ secrets.AWS_REGION }}"

    - name: Terraform Apply
      if: github.event_name == 'push' && github.ref == 'refs/heads/master'
      working-directory: terraform
      run: terraform apply -auto-approve -var "access_key=${{ secrets.AWS_ACCESS_KEY_ID }}" -var "secret_key=${{ secrets.AWS_SECRET_ACCESS_KEY }}" -var "region=${{ secrets.AWS_REGION }}"

    - name: Configure AWS credentials
      uses: aws-actions/configure-aws-credentials@v1
      with:
        role-session-name: awssession
        role-to-assume: ${{secrets.AWS_IAM_ROLE}}
        aws-region: ${{secrets.AWS_REGION}}
    - name: Login to Amazon ECR
      uses: aws-actions/amazon-ecr-login@v1

    - name: Build Docker Image
      working-directory: app
      run: |
        docker build -t nodejs-app .
        
    - name: Tag Docker Image
      working-directory: app
      run: |
        docker tag nodejs-app:latest ${{secrets.AWS_ACCOUNT_ID}}.dkr.ecr.${{secrets.AWS_REGION}}.amazonaws.com/prueba-repository:latest

    - name: Push Docker Image to ECR
      working-directory: app
      run: |
        docker push ${{secrets.AWS_ACCOUNT_ID}}.dkr.ecr.${{secrets.AWS_REGION}}.amazonaws.com/prueba-repository:latest      

  test:
    name: Test
    runs-on: ubuntu-latest
    needs: deploy 
      
    steps:
    - name: Checkout Code
      uses: actions/checkout@v4
      
    - name: Setup Node.js
      uses: actions/setup-node@v3
      with:
        node-version: 18
      
    - name: Install Dependencies
      working-directory: app
      run: npm install
      
    - name: Run Tests
      working-directory: app
      run: npm run test  
```

---

## **Pruebas Automatizadas**
El microservicio incluye pruebas automatizadas utilizando **Jest**:

### **Ejemplo de Prueba Unitaria**
```javascript
const request = require('supertest');
const app = require('../src/index');

test('Debe responder con mensaje de confirmación', async () => {
  const res = await request(app)
    .post('/DevOps')
    .set('X-Parse-REST-API-Key', '2f5ae96c-b558-4c7b-a590-a501ae1c3f6c')
    .send({
      message: "This is a test",
      to: "Juan Perez",
      from: "Rita Asturia",
      timeToLifeSec: 45
    });

  expect(res.statusCode).toBe(200);
  expect(res.body.message).toBe("Hello Juan Perez your message will be sent");
});
```

### **Cobertura de Código**
La cobertura es analizada con `jest --coverage`, asegurando **97.05%** de cobertura.


