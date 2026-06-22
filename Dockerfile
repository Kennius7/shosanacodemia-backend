FROM node:22-alpine AS builder

WORKDIR /shosanacodemia-backend

COPY package*.json ./
RUN npm ci

COPY . .

RUN npx prisma generate
RUN npm run build

FROM node:22-alpine

WORKDIR /shosanacodemia-backend

COPY package*.json ./
RUN npm ci --omit=dev

COPY --from=builder /shosanacodemia-backend/dist ./dist
COPY --from=builder /shosanacodemia-backend/prisma ./prisma
COPY --from=builder /shosanacodemia-backend/node_modules/.prisma ./node_modules/.prisma

EXPOSE 4000

CMD ["node", "dist/src/main.js"]