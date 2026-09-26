// Pagination par décalage : ?limit=<1..200>&offset=<0..>. On lit une ligne de
// plus que demandé pour savoir s'il reste une page, sans requête COUNT ; la
// réponse reste un tableau JSON (compatible avec les anciens clients) et
// l'en-tête X-Has-More indique la suite.
const MAX_LIMIT = 200;

function pageParams(query, defaultLimit = 50) {
  const limit = Math.min(Math.max(parseInt(query.limit, 10) || defaultLimit, 1), MAX_LIMIT);
  const offset = Math.max(parseInt(query.offset, 10) || 0, 0);
  return { limit, offset };
}

function sendPage(res, rows, limit) {
  const hasMore = rows.length > limit;
  res.set('X-Has-More', String(hasMore));
  res.json(hasMore ? rows.slice(0, limit) : rows);
}

module.exports = { pageParams, sendPage, MAX_LIMIT };
